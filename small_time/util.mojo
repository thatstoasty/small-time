from builtin.globals import global_constant


fn rjust(s: String, width: Int, fill: String = " ") -> String:
    """Right-justify a string by padding with fill characters on the left.

    Args:
        s: The string to right-justify.
        width: The minimum width of the result.
        fill: The fill character (default: space).

    Returns:
        The right-justified string.
    """
    var pad = width - len(s)
    if pad <= 0:
        return s
    var result = String()
    for _ in range(pad):
        result.write(fill)
    result.write(s)
    return result


comptime StackArray[T: Copyable, size: Int] = InlineArray[T, size]
"""A stack-allocated array of fixed size.

Parameters:
    T: The element type.
    size: The size of the array.
"""


@always_inline
fn lut[I: Indexer, //, A: StackArray](i: I) -> A.ElementType:
    """Returns the value at the given index from a global constant array.

    Parameters:
        I: The indexer type.
        A: The type of the global constant array.

    Args:
        i: The index to retrieve.

    Returns:
        The value at the given index.
    """
    return global_constant[A]().unsafe_get(i).copy()
