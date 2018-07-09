module redkangaroo.exceptions;

import std.string;

class ConfigLoadException : Exception
{
    this(string configFileName, string file = __FILE__, size_t line = __LINE__) {
        super(format("Invalid %s file. Please correct it and try again.", configFileName), file, line);
    }
}