from std.builtin.globals import global_constant


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


fn as_byte[char: StringSlice]() -> Byte:
    """Converts a character to a byte.

    Parameters:
        char: The character type.

    Returns:
        The byte representation of the character.
    """
    comptime assert len(char) == 1, "Input must be a single character."
    return char.as_bytes()[0]
