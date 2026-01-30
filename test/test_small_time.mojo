import small_time._libc as libc
import testing
from _py import py_dt_datetime, py_time
from python import PythonObject
from small_time.time_zone import TIMEZONE_MAP, TimeZone, from_utc
from testing import TestSuite

from small_time.small_time import SmallTime, Specification, from_ordinal, from_timestamp, now, parse_time_with_format


# TODO: Need a better way to test this, since it's not deterministic.
fn assert_datetime_equal(dt: SmallTime, py_dt: PythonObject) raises:
    testing.assert_true(
        dt.year == UInt(Int(String(py_dt.year)))
        and dt.month == Int(String(py_dt.month))
        and dt.hour == Int(String(py_dt.hour))
        and dt.minute == Int(String(py_dt.minute))
        and dt.second == Int(String(py_dt.second)),
        "dt: " + String(dt) + " is not equal to py_dt: " + String(py_dt),
    )


fn test_now() raises:
    assert_datetime_equal(py_dt=py_dt_datetime().now(), dt=now())


fn test_utc_now() raises:
    assert_datetime_equal(py_dt=py_dt_datetime().utcnow(), dt=now(utc=True))


fn test_from_timestamp() raises:
    assert_datetime_equal(py_dt=py_dt_datetime().now(), dt=from_timestamp(Float64(libc.get_time_of_day().seconds)))
    assert_datetime_equal(py_dt=py_dt_datetime().utcnow(), dt=from_timestamp(Float64(libc.get_time_of_day().seconds), utc=True))


fn test_iso_format() raises:
    var d0 = SmallTime(2023, 10, 1, 0, 0, 0, 1234)
    testing.assert_equal(d0.isoformat(), "2023-10-01T00:00:00.001234+00:00")
    testing.assert_equal(d0.isoformat[Specification.SECONDS](), "2023-10-01T00:00:00+00:00")
    testing.assert_equal(d0.isoformat[Specification.MILLISECONDS](), "2023-10-01T00:00:00.001+00:00")

    # with TimeZone
    var d1 = SmallTime(2023, 10, 1, 0, 0, 0, 1234, materialize[TIMEZONE_MAP]()["Asia/Shanghai"])
    # var d1 = SmallTime(2023, 10, 1, 0, 0, 0, 1234, TimeZone.ASIA_SHANGHAI)
    testing.assert_equal(d1.isoformat[Specification.SECONDS](), "2023-10-01T00:00:00+08:00")


fn test_strptime() raises:
    var m = parse_time_with_format("20-01-2023 15:49:10", "%d-%m-%Y %H:%M:%S")
    testing.assert_equal(String(m), "2023-01-20T15:49:10.000000+00:00")

    # TODO: Need to add more tests for different types of timestamps to parse.
    # Not sure if this is a valid timestamp? Python can parse it so...
    # m = parse_time_with_format("2023-10-18 15:49:10 +0800", "%Y-%m-%d %H:%M:%S %z")
    # testing.assert_equal(String(m), "2023-10-18T15:49:10.000000+00:00")

    m = parse_time_with_format("2023-10-18 15:49:10", "%Y-%m-%d %H:%M:%S", "+09:00")
    testing.assert_equal(String(m), "2023-10-18T15:49:10.000000+09:00")


fn test_ordinal() raises:
    comptime m = SmallTime(2023, 10, 1)
    var o = m.to_ordinal()
    testing.assert_equal(o, 738794)

    var m2 = from_ordinal(o)
    testing.assert_equal(m2.year, 2023)
    testing.assert_equal(m.month, 10)
    testing.assert_equal(m.day, 1)


fn test_sub() raises:
    var rhs = SmallTime(2023, 10, 1, 10, 0, 0)
    var result = SmallTime(2023, 10, 1, 10, 0, 0, 1) - rhs
    testing.assert_equal(result.microseconds, 1)
    testing.assert_equal(String(result), "0:00:00000001")

    result = SmallTime(2023, 10, 1, 10, 0, 1) - rhs
    testing.assert_equal(result.seconds, 1)
    testing.assert_equal(String(result), "0:00:01")

    result = SmallTime(2023, 10, 1, 10, 1, 0) - rhs
    testing.assert_equal(result.seconds, 60)
    testing.assert_equal(String(result), "0:01:00")

    result = SmallTime(2023, 10, 2, 10, 0, 0) - rhs
    testing.assert_equal(result.days, 1)
    testing.assert_equal(String(result), "1 day, 0:00:00")

    result = SmallTime(2023, 10, 3, 10, 1, 1) - rhs
    testing.assert_equal(result.days, 2)
    testing.assert_equal(String(result), "2 days, 0:01:01")


fn test_format() raises:
    comptime time = SmallTime(2024, 2, 1, 3, 4, 5, 123456)
    testing.assert_equal(time.format["YYYY-MM-DD HH:mm:ss.SSS ZZ"](), "2024-02-01 03:04:05.123 +00:00")
    testing.assert_equal(time.format["Y-YY-YYY-YYYY M-MM D-DD"](), "Y-24--2024 2-02 1-01")
    testing.assert_equal(time.format["H-HH-h-hh m-mm s-ss"](), "3-03-3-03 4-04 5-05")
    testing.assert_equal(time.format["S-SS-SSS-SSSS-SSSSS-SSSSSS"](), "1-12-123-1234-12345-123456")
    testing.assert_equal(time.format["d-dd-ddd-dddd"](), "4--Thu-Thursday")


fn test_format_brackets() raises:
    comptime time = SmallTime(2024, 2, 1, 3, 4, 5, 123456)
    # "Do" not supported in SmallTime yet, so skipping this test.
    # testing.assert_equal(m.format[
    #     "[It happened on] MMMM Do [in the][ year] YYYY [a long time ago]"
    # ](), "It happened on February 1st in the year 2024 a long time ago")
    testing.assert_equal(time.format["MMMM D, YYYY [at] h:mma"](), "February 1, 2024 at 3:04am")
    testing.assert_equal(time.format["[MMMM] M D, YYYY [at] h:mma"](), "MMMM 2 1, 2024 at 3:04am")
    testing.assert_equal(time.format["[[[ ]]"](), "[[ ]")
    testing.assert_equal(
        time.format["[It happened on] MMMM D[st] [in the][ year] YYYY [a long time ago]"](),
        "It happened on February 1st in the year 2024 a long time ago",
    )
    testing.assert_equal(time.format["[I'm][ entirely][ escaped,][ weee!]"](), "I'm entirely escaped, weee!")

    # Escaping is atomic: brackets inside brackets are treated literally
    testing.assert_equal(time.format["YYYY[Y] [[]MM[]][M]"](), "2024Y [02]M")


fn main() raises:
    TestSuite.discover_tests[__functions_in_module()]().run()
