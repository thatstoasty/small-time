"""Calendar math functions."""
from small_time.util import lut


comptime _DAYS_BEFORE_MONTH: InlineArray[UInt16, 13] = [
    -1,
    0,
    31,
    59,
    90,
    120,
    151,
    181,
    212,
    243,
    273,
    304,
    334,
]  # -1 is a placeholder for indexing purposes.
"""Number of days before each month in a common year."""


comptime _DAYS_IN_MONTH: InlineArray[UInt8, 13] = [-1, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
"""Number of days in each month, not counting leap years."""


def check_if_leap_year(year: UInt) -> Bool:
    """If the year is a leap year.

    Args:
        year: The year to check.

    Returns:
        True if the year is a leap year, False otherwise.

    Notes:
        A year is a leap year if it is divisible by 4, but not by 100, unless it is divisible by 400.
    """
    return year % 4 == 0 and (year % 100 != 0 or year % 400 == 0)


def days_before_next_calendar_year(year: UInt) -> UInt:
    """Number of days before January 1st of year.

    Args:
        year: The year to check.

    Returns:
        Number of days before January 1st of year.

    Notes:
        year -> number of days before January 1st of year.
    """
    var y = year - 1
    return y * 365 + y // 4 - y // 100 + y // 400


def days_in_month(year: UInt, month: UInt8) -> UInt8:
    """Number of days in a month in a year.

    Args:
        year: The year to check.
        month: The month to check.

    Returns:
        Number of days in that month in that year.

    Notes:
        year, month -> number of days in that month in that year.
    """
    if month == 2 and check_if_leap_year(year):
        return 29
    return lut[_DAYS_IN_MONTH](month)


def days_before_month(year: UInt, month: UInt8) -> UInt16:
    """Number of days in year preceding first day of month.

    Args:
        year: The year to check.
        month: The month to check.

    Returns:
        Number of days in year preceding first day of month.

    Notes:
        year, month -> number of days in year preceding first day of month.
    """
    if month > 2 and check_if_leap_year(year):
        return lut[_DAYS_BEFORE_MONTH](month) + 1
    return lut[_DAYS_BEFORE_MONTH](month)


def ymd_to_ordinal(year: UInt, month: UInt8, day: UInt8) -> UInt:
    """Convert year, month, day to ordinal, considering `01-Jan-0001` as day 1.

    Args:
        year: The year to check.
        month: The month to check.
        day: The day to check.

    Returns:
        Ordinal formatted date, considering `01-Jan-0001` as day 1.
    """
    return days_before_next_calendar_year(year) + UInt(days_before_month(year, month)) + UInt(day)
