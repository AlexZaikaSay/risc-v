find_program(RISCV_AS  riscv64-elf-as      REQUIRED)
find_program(RISCV_LD  riscv64-elf-ld      REQUIRED)
find_program(RISCV_OC  riscv64-elf-objcopy REQUIRED)

set(LINKER_SCRIPT ${CMAKE_CURRENT_SOURCE_DIR}/link.ld)

file(GLOB ASM_SOURCES ${CMAKE_CURRENT_SOURCE_DIR}/asm/*.s)

foreach(SRC ${ASM_SOURCES})
    get_filename_component(NAME ${SRC} NAME_WE)
    set(OBJ ${CMAKE_CURRENT_BINARY_DIR}/${NAME}.o)
    set(ELF ${CMAKE_CURRENT_BINARY_DIR}/${NAME}.elf)
    set(BIN ${CMAKE_CURRENT_BINARY_DIR}/${NAME}.bin)
    set(MEM ${CMAKE_CURRENT_BINARY_DIR}/${NAME}.mem)

    add_custom_command(OUTPUT ${OBJ}
        COMMAND ${RISCV_AS} -march=rv32i -mabi=ilp32 -o ${OBJ} ${SRC}
        DEPENDS ${SRC})

    add_custom_command(OUTPUT ${ELF}
        COMMAND ${RISCV_LD} -m elf32lriscv -T ${LINKER_SCRIPT} -o ${ELF} ${OBJ}
        DEPENDS ${OBJ} ${LINKER_SCRIPT})

    add_custom_command(OUTPUT ${BIN}
        COMMAND ${RISCV_OC} -O binary ${ELF} ${BIN}
        DEPENDS ${ELF})

    add_custom_command(OUTPUT ${MEM}
        COMMAND ${CMAKE_COMMAND} -DINPUT=${BIN} -DOUTPUT=${MEM}
                -P ${CMAKE_SOURCE_DIR}/cmake/hexdump.cmake
        DEPENDS ${BIN})

    add_custom_target(${NAME} ALL DEPENDS ${MEM})
endforeach()
