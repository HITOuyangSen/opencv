macro(listify OUT_LIST IN_STRING)
    string(REPLACE " " ";" ${OUT_LIST} ${IN_STRING})
endmacro()

listify(MEX_INCLUDE_DIRS_LIST ${MEX_INCLUDE_DIRS})
file(GLOB SOURCE_FILES "${CMAKE_CURRENT_BINARY_DIR}/src/*.cpp")
foreach(SOURCE_FILE ${SOURCE_FILES})
    # strip out the filename
    get_filename_component(FILENAME ${SOURCE_FILE} NAME_WE)
    # compie the source file using mex
    if (NOT EXISTS ${CMAKE_CURRENT_BINARY_DIR}/+cv/${FILENAME}.${MATLAB_MEXEXT})
        execute_process(
            COMMAND ${MATLAB_MEX_SCRIPT} ${MEX_OPTS} "CXXFLAGS=\$CXXFLAGS ${MEX_CXXFLAGS}" ${MEX_INCLUDE_DIRS_LIST} 
                    ${MEX_LIB_DIR} ${MEX_LIBS} ${SOURCE_FILE}
            WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/+cv
            OUTPUT_QUIET
            ERROR_VARIABLE FAILED
        )
    endif()
    # TODO: If a mex file fails to compile, should we error out?
    if (FAILED)
        message(FATAL_ERROR "Failed to compile ${FILENAME}: ${FAILED}")
    endif()
endforeach()
