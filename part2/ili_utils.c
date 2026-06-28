
#include <asm/desc.h>

// TO_DO: store the address of the IDT at the parameter given
void my_store_idt(struct desc_ptr *idtr) {
    asm volatile("sidt %0" : : "m" (*idtr));
}////

// TO_DO: load the address of the IDT from the parameter given
void my_load_idt(struct desc_ptr *idtr) {
    asm volatile("lidt %0" : : "m"(*idtr));
}

// TO_DO: set the address in the right place at the parameter gate
// try to remember - how this information is stored?
void my_set_gate_offset(gate_desc *gate, unsigned long addr) {
    gate->offset_low = (u16)(addr & 0xFFFF);
    gate->offset_middle = (u16)((addr >> 16) & 0xFFFF);
    gate->offset_high = (u32)(addr >> 32);
}

// TO_DO: return val is the address stored at the parameter gate_desc gate
// try to remember - how this information is stored?
unsigned long my_get_gate_offset(gate_desc *gate) {
    unsigned long ret = 0;
    ret |= gate->offset_low;
    ret |= (gate->offset_middle << 16);
    ret |= (gate->offset_high << 32);
    return ret; 
}
