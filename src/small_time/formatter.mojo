from collections import InlineList, InlineArray
from .time_zone import UTC_TZ

alias MONTH_NAMES = InlineArray[String, 13](
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
)
alias MONTH_ABBREVIATIONS = InlineArray[String, 13](
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
)
alias DAY_NAMES = InlineArray[String, 8](
    "",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday",
)
alias DAY_ABBREVIATIONS = InlineArray[String, 8]("", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun")
alias formatter = _Formatter()


struct _Formatter:
    var _sub_chrs: InlineList[Int, 128]

    fn __init__(inout self):
        self._sub_chrs = InlineList[Int, 128]()
        for i in range(128):
            self._sub_chrs[i] = 0
        self._sub_chrs[_Y] = 4
        self._sub_chrs[_M] = 4
        self._sub_chrs[_D] = 2
        self._sub_chrs[_d] = 4
        self._sub_chrs[_H] = 2
        self._sub_chrs[_h] = 2
        self._sub_chrs[_m] = 2
        self._sub_chrs[_s] = 2
        self._sub_chrs[_S] = 6
        self._sub_chrs[_Z] = 3
        self._sub_chrs[_A] = 1
        self._sub_chrs[_a] = 1

    fn format(self, m: SmallTime, fmt: String) -> String:
        """
        "YYYY[abc]MM" -> replace("YYYY") + "abc" + replace("MM")
        """
        if len(fmt) == 0:
            return ""

        var result: String = ""
        var in_bracket = False
        var start = 0

        for i in range(len(fmt)):
            if fmt[i] == "[":
                if in_bracket:
                    result += "["
                else:
                    in_bracket = True
                result += self.replace(m, fmt[start:i])
                start = i + 1
            elif fmt[i] == "]":
                if in_bracket:
                    result += fmt[start:i]
                    in_bracket = False
                else:
                    result += self.replace(m, fmt[start:i])
                    result += "]"
                start = i + 1

        if in_bracket:
            result += "["

        if start < len(fmt):
            result += self.replace(m, fmt[start:])
        return result

    fn replace(self, m: SmallTime, fmt: String) -> String:
        """
        split token and replace
        """
        if len(fmt) == 0:
            return ""

        var result: String = ""
        var matched_byte = 0
        var matched_count = 0
        for i in range(len(fmt)):
            var c = ord(fmt[i])

            # If the current character is not a token, add it to the result.
            if c > 127 or self._sub_chrs[c] == 0:
                if matched_byte > 0:
                    result += self.replace_token(m, matched_byte, matched_count)
                    matched_byte = 0
                result += fmt[i]
                continue

            # If the current character is the same as the previous one, increment the count.
            if c == matched_byte:
                matched_count += 1
                continue

            # If the current character is different from the previous one, replace the previous tokens
            # and move onto the next token to track.
            result += self.replace_token(m, matched_byte, matched_count)
            matched_byte = c
            matched_count = 1

        # If no tokens were found, append an empty string and return the original.
        if matched_byte > 0:
            result += self.replace_token(m, matched_byte, matched_count)
        return result

    fn replace_token(self, m: SmallTime, token: Int, token_count: Int) -> String:
        if token == _Y:
            if token_count == 1:
                return "Y"
            if token_count == 2:
                return str(m.year)[-2:]
                # return str(m.year).rjust(4, "0")[2:4]
            if token_count == 4:
                return str(m.year).rjust(4, "0")
        elif token == _M:
            if token_count == 1:
                return str(m.month)
            if token_count == 2:
                return str(m.month).rjust(2, "0")
            if token_count == 3:
                return MONTH_ABBREVIATIONS[int(m.month)]
            if token_count == 4:
                return MONTH_NAMES[int(m.month)]
        elif token == _D:
            if token_count == 1:
                return str(m.day)
            if token_count == 2:
                return str(m.day).rjust(2, "0")
        elif token == _H:
            if token_count == 1:
                return str(m.hour)
            if token_count == 2:
                return str(m.hour).rjust(2, "0")
        elif token == _h:
            var h_12 = m.hour
            if m.hour > 12:
                h_12 -= 12
            if token_count == 1:
                return str(h_12)
            if token_count == 2:
                return str(h_12).rjust(2, "0")
        elif token == _m:
            if token_count == 1:
                return str(m.minute)
            if token_count == 2:
                return str(m.minute).rjust(2, "0")
        elif token == _s:
            if token_count == 1:
                return str(m.second)
            if token_count == 2:
                return str(m.second).rjust(2, "0")
        elif token == _S:
            if token_count == 1:
                return str(m.microsecond // 100000)
            if token_count == 2:
                return str(m.microsecond // 10000).rjust(2, "0")
            if token_count == 3:
                return str(m.microsecond // 1000).rjust(3, "0")
            if token_count == 4:
                return str(m.microsecond // 100).rjust(4, "0")
            if token_count == 5:
                return str(m.microsecond // 10).rjust(5, "0")
            if token_count == 6:
                return str(m.microsecond).rjust(6, "0")
        elif token == _d:
            if token_count == 1:
                return str(m.iso_weekday())
            if token_count == 3:
                return DAY_ABBREVIATIONS[m.iso_weekday()]
            if token_count == 4:
                return DAY_NAMES[m.iso_weekday()]
        elif token == _Z:
            if token_count == 3:
                return str(UTC_TZ) if not m.tz else str(m.tz)
            var separator = "" if token_count == 1 else ":"
            if not m.tz:
                return UTC_TZ.format(separator)
            else:
                return m.tz.format(separator)

        elif token == _a:
            return "am" if m.hour < 12 else "pm"
        elif token == _A:
            return "AM" if m.hour < 12 else "PM"
        return ""


alias _Y = ord("Y")
alias _M = ord("M")
alias _D = ord("D")
alias _d = ord("d")
alias _H = ord("H")
alias _h = ord("h")
alias _m = ord("m")
alias _s = ord("s")
alias _S = ord("S")
alias _X = ord("X")
alias _x = ord("x")
alias _Z = ord("Z")
alias _A = ord("A")
alias _a = ord("a")
