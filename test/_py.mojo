from std.python import Python, PythonObject


def py_dt_datetime() raises -> PythonObject:
    var _datetime = Python.import_module("datetime")
    return _datetime.datetime


def py_time() raises -> PythonObject:
    var _time = Python.import_module("time")
    return _time
