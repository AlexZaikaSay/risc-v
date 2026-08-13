cmake_minimum_required(VERSION 3.12)
project(RISC-V NONE)

find_program(IVERILOG_EXECUTABLE iverilog REQUIRED)
find_program(VVP_EXECUTABLE vvp REQUIRED)

add_subdirectory(tests)


set(SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/src)
set(TESTBENCH_DIR ${CMAKE_CURRENT_SOURCE_DIR}/testbenches)


# All RTL files
file(GLOB_RECURSE RTL_SOURCES
    "${SOURCE_DIR}/*.sv"
)

# Every testbench
file(GLOB TESTBENCHS
    "${TESTBENCH_DIR}/tb_*.sv"
)

file(GLOB_RECURSE TESTVECTORS
    "${TESTBENCH_DIR}/data/*.tv"
)

# Convenience target
add_custom_target(sim_all ALL
    COMMENT "Running all testbenches"
)

foreach(TB_FILE ${TESTBENCHS})

    get_filename_component(TB_NAME ${TB_FILE} NAME_WE)

    set(OUTPUT_FILE "${CMAKE_CURRENT_BINARY_DIR}/${TB_NAME}.out")
    set(VCD_FILE    "${CMAKE_CURRENT_BINARY_DIR}/${TB_NAME}.vcd")

    list(APPEND GENERATED_FILES
        ${OUTPUT_FILE}
        ${VCD_FILE}
    )

    add_custom_command(
        OUTPUT ${OUTPUT_FILE}

        COMMAND
            ${IVERILOG_EXECUTABLE}
            -g2012
            -o ${OUTPUT_FILE}
            -I ${SOURCE_DIR}
            ${TB_FILE}

        DEPENDS
            ${RTL_SOURCES}
            ${TB_FILE}
            ${TESTVECTORS}

        COMMENT "Compiling ${TB_NAME}"
    )

    add_custom_target(sim_${TB_NAME}
        DEPENDS ${OUTPUT_FILE}
        COMMAND ${VVP_EXECUTABLE} ${OUTPUT_FILE}
        COMMENT "Running ${TB_NAME}"
    )

    if(TB_NAME STREQUAL "tb_01_imem")
        add_dependencies(sim_${TB_NAME} t1)
    endif()

    add_custom_target(debug_${TB_NAME}
        DEPENDS ${OUTPUT_FILE}
        COMMAND ${VVP_EXECUTABLE} -s ${OUTPUT_FILE}
        COMMENT "Interactive debugging ${TB_NAME}"
    )

    if(TB_NAME STREQUAL "tb_01_imem")
        add_dependencies(debug_${TB_NAME} t1)
    endif()
    
    add_dependencies(sim_all sim_${TB_NAME})

endforeach()

set_property(DIRECTORY APPEND PROPERTY
    ADDITIONAL_CLEAN_FILES "${GENERATED_FILES}"
)
