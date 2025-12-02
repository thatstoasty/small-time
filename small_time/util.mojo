from builtin.globals import global_constant


comptime StackArray[T: Copyable & Movable, size: Int] = InlineArray[T, size]


@always_inline
fn lut[A: StackArray](i: Some[Indexer]) -> A.ElementType:
    """Returns the value at the given index from a global constant array.

    Parameters:
        A: The type of the global constant array.

    Args:
        i: The index to retrieve.

    Returns:
        The value at the given index.
    """
    return global_constant[A]().unsafe_get(i).copy()
