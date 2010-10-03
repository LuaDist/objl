# Copyright (C) 2007-2009 LuaDist.
# Created by Peter Kapec
# Redistribution and use of this file is allowed according to the terms of the MIT license.
# For details see the COPYRIGHT file distributed with LuaDist.
# Please note that the package source code is licensed under its own license.

PROJECT(objl NONE)
CMAKE_MINIMUM_REQUIRED(VERSION 2.6)
INCLUDE(dist.cmake)

# Install all files and documentation
INSTALL (DIRECTORY lib/ DESTINATION ${INSTALL_LMOD})
INSTALL (FILES AUTHORS CHANGELOG INSTALL LICENSE README THANKS TODO LGPL.txt DESTINATION ${INSTALL_DATA})
INSTALL (DIRECTORY doc/ DESTINATION ${INSTALL_DOC})
INSTALL (DIRECTORY examples/ DESTINATION ${INSTALL_EXAMPLE})
INSTALL (DIRECTORY test/ DESTINATION ${INSTALL_TEST})
INSTALL (DIRECTORY tools/ DESTINATION ${INSTALL_FOO})
