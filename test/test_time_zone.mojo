from std import testing
from std.testing import TestSuite
from small_time.time_zone import TIMEZONE_MAP, TimeZone, from_utc


fn test_time_zone() raises:
    testing.assert_equal(from_utc("UTC+0800").offset, 28800)
    testing.assert_equal(from_utc("UTC+08:00").offset, 28800)
    testing.assert_equal(from_utc("UTC08:00").offset, 28800)
    testing.assert_equal(from_utc("UTC0800").offset, 28800)
    testing.assert_equal(from_utc("+08:00").offset, 28800)
    testing.assert_equal(from_utc("+0800").offset, 28800)
    testing.assert_equal(from_utc("08").offset, 28800)


fn test_time_zone_from_name() raises:
    # Test with a known time zone
    tz = materialize[TIMEZONE_MAP]()["Asia/Shanghai"]
    testing.assert_equal(tz.name, "Asia/Shanghai")
    testing.assert_equal(tz.offset, 28800)  # +08:00 in seconds

    # Test with an invalid time zone
    testing.assert_false(materialize[TIMEZONE_MAP]().get("Invalid/TimeZone"))


fn main() raises:
    TestSuite.discover_tests[__functions_in_module()]().run()
