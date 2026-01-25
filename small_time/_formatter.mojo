from small_time.util import lut


comptime MONTH_NAMES: InlineArray[String, 13] = [
    "",
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December",
]
"""The full month names."""

comptime MONTH_ABBREVIATIONS: InlineArray[String, 13] = [
    "",
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec",
]
"""The month name abbreviations."""
comptime DAY_NAMES: InlineArray[String, 8] = [
    "",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday",
]
"""The full day names."""
comptime DAY_ABBREVIATIONS: InlineArray[String, 8] = [
    "",
    "Mon",
    "Tue",
    "Wed",
    "Thu",
    "Fri",
    "Sat",
    "Sun",
]
"""The day name abbreviations."""


@fieldwise_init
struct Token(Copyable, Equatable, ImplicitlyCopyable, Movable):
    """Token for the formatter."""

    var char: Byte
    """The character of the token."""

    comptime _Y = Byte(ord("Y"))
    comptime _M = Byte(ord("M"))
    comptime _D = Byte(ord("D"))
    comptime _d = Byte(ord("d"))
    comptime _H = Byte(ord("H"))
    comptime _h = Byte(ord("h"))
    comptime _m = Byte(ord("m"))
    comptime _s = Byte(ord("s"))
    comptime _S = Byte(ord("S"))
    comptime _X = Byte(ord("X"))
    comptime _x = Byte(ord("x"))
    comptime _Z = Byte(ord("Z"))
    comptime _A = Byte(ord("A"))
    comptime _a = Byte(ord("a"))

    fn __eq__(self, other: Self) -> Bool:
        """Checks if two tokens are equal.

        Args:
            other: The other token to compare with.

        Returns:
            True if the tokens are equal, False otherwise.
        """
        return self.char == other.char

    fn __eq__(self, other: Byte) -> Bool:
        """Checks if two tokens are equal.

        Args:
            other: The other token to compare with.

        Returns:
            True if the tokens are equal, False otherwise.
        """
        return self.char == other


@register_passable("trivial")
struct BracketBounds(Copyable, ImplicitlyCopyable, Movable):
    """Bracket bounds."""

    var start: Int
    """Start index of the bracket."""
    var end: Int
    """End index of the bracket."""

    fn __init__(out self, start: Int, end: Int):
        self.start = start
        self.end = end


fn find_brackets[template: StringSlice]() -> List[BracketBounds]:
    """Finds the start index of the first bracket in the template."""
    var in_bracket = False
    var brackets = List[BracketBounds]()

    @parameter
    for i in range(len(template)):
        if template[i:i+1] == "[" and not in_bracket:
            brackets.append(BracketBounds(i, -1))
            in_bracket = True
        elif template[i:i+1] == "]" and in_bracket:
            brackets[-1].end = i
            in_bracket = False

    return brackets^


fn build_formatter_lookup(out chars: InlineArray[Int, 128]):
    chars = InlineArray[Int, 128](fill=0)
    chars[Token._Y] = 4
    chars[Token._M] = 4
    chars[Token._D] = 2
    chars[Token._d] = 4
    chars[Token._H] = 2
    chars[Token._h] = 2
    chars[Token._m] = 2
    chars[Token._s] = 2
    chars[Token._S] = 6
    chars[Token._Z] = 3
    chars[Token._A] = 1
    chars[Token._a] = 1


comptime SUB_CHARS = build_formatter_lookup()


# TODO (Mikhail): Add support for "Do" for day of the month with ordinal suffix (1st, 2nd, 3rd, etc.)
fn format[template: StringSlice](time: SmallTime) -> String:
    """Formats the given time value using the specified format string.
    `"YYYY[abc]MM" -> replace("YYYY") + "abc" + replace("MM")`.

    Parameters:
        template: Format string template to use for formatting the time.

    Args:
        time: SmallTime datetime to format.

    Returns:
        Formatted time string.
    """

    @parameter
    if len(template) == 0:
        return String()

    comptime bounds = find_brackets[template]()
    var b = materialize[bounds]()

    @parameter
    if len(bounds) == 0:
        # No brackets found, just replace the template.
        return replace[template](time)
    elif len(bounds) == 1:
        return String(
            replace[template[: bounds[0].start]](time),
            template[b[0].start + 1 : b[0].end],
            replace[template[bounds[0].end + 1 :]](time),
        )
    else:
        var result = String(replace[template[: bounds[0].start]](time), template[b[0].start + 1 : b[0].end])

        @parameter
        for i in range(1, len(bounds)):
            comptime start = bounds[i].start
            comptime end = bounds[i].end
            result.write(replace[template[bounds[i - 1].end + 1 : start]](time), template[start + 1 : end])

            @parameter
            if i == len(bounds) - 1:
                # Replace the last part of the template after the last bracket.
                result.write(replace[template[end + 1 :]](time))
        return result^


fn replace[template: StringSlice](time: SmallTime) -> String:
    """Replaces the tokens in the given format string with the corresponding values.

    Parameters:
        template: Format string to replace tokens in.

    Args:
        time: SmallTime datetime to replace tokens in.

    Returns:
        Formatted time string.
    """

    @parameter
    if len(template) == 0:
        return String()

    var matched_byte = 0
    var matched_count = 0

    var result = String()

    @parameter
    for i in range(len(template)):
        var byte = ord(template[i:i+1])
        # If the current character is not a token, add it to the result.
        if byte > 127 or lut[SUB_CHARS](byte) == 0:
            if matched_byte > 0:
                # If we have a matched token, replace it with the corresponding value.
                result.write(replace_token(time, matched_byte, matched_count))
                matched_byte = 0
            result.write(template[i:i+1])
            continue

        # If the current character is the same as the previous one, increment the count.
        if byte == matched_byte:
            matched_count += 1
            continue

        # If the current character is different from the previous one, replace the previous tokens
        # and move onto the next token to track.
        result.write(replace_token(time, matched_byte, matched_count))
        matched_byte = byte
        matched_count = 1

    # If no tokens were found, append an empty string and return the original.
    if matched_byte > 0:
        result.write(replace_token(time, matched_byte, matched_count))
    return result


fn replace_token(time: SmallTime, token: Byte, token_count: Int) -> String:
    """Replaces the given token with the corresponding value from the SmallTime object.

    Args:
        time: SmallTime datetime to replace tokens in.
        token: The token to replace.
        token_count: The number of times the token appears in the format string.

    Returns:
        The string representation of the token value.
    """
    if token == Token._Y:
        if token_count == 1:
            return "Y"
        if token_count == 2:
            return String(String(time.year).rjust(4, "0")[2:4])
        if token_count == 4:
            return String(time.year).rjust(4, "0")
    elif token == Token._M:
        if token_count == 1:
            return String(time.month)
        if token_count == 2:
            return String(time.month).rjust(2, "0")
        if token_count == 3:
            return materialize[MONTH_ABBREVIATIONS]()[time.month]
        if token_count == 4:
            return materialize[MONTH_NAMES]()[time.month]
    elif token == Token._D:
        if token_count == 1:
            return String(time.day)
        if token_count == 2:
            return String(time.day).rjust(2, "0")
    elif token == Token._H:
        if token_count == 1:
            return String(time.hour)
        if token_count == 2:
            return String(time.hour).rjust(2, "0")
    elif token == Token._h:
        var h_12 = time.hour
        if time.hour > 12:
            h_12 -= 12
        if token_count == 1:
            return String(h_12)
        if token_count == 2:
            return String(h_12).rjust(2, "0")
    elif token == Token._m:
        if token_count == 1:
            return String(time.minute)
        if token_count == 2:
            return String(time.minute).rjust(2, "0")
    elif token == Token._s:
        if token_count == 1:
            return String(time.second)
        if token_count == 2:
            return String(time.second).rjust(2, "0")
    elif token == Token._S:
        if token_count == 1:
            return String(time.microsecond // 100000)
        if token_count == 2:
            return String(time.microsecond // 10000).rjust(2, "0")
        if token_count == 3:
            return String(time.microsecond // 1000).rjust(3, "0")
        if token_count == 4:
            return String(time.microsecond // 100).rjust(4, "0")
        if token_count == 5:
            return String(time.microsecond // 10).rjust(5, "0")
        if token_count == 6:
            return String(time.microsecond).rjust(6, "0")
    elif token == Token._d:
        if token_count == 1:
            return String(time.iso_weekday())
        if token_count == 3:
            return materialize[DAY_ABBREVIATIONS]()[time.iso_weekday()]
        if token_count == 4:
            return materialize[DAY_NAMES]()[time.iso_weekday()]
    elif token == Token._Z:
        if token_count == 3:
            return time.time_zone.name
        var separator = "" if token_count == 1 else ":"
        return time.time_zone.format(separator)

    elif token == Token._a:
        return "am" if time.hour < 12 else "pm"
    elif token == Token._A:
        return "AM" if time.hour < 12 else "PM"
    return ""
