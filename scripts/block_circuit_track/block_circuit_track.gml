function block_circuit_track(x, y, z){
	TAG_List("pos", 3, 3)
		buffer_write_int_be(99 - y)
		buffer_write_int_be(z)
		buffer_write_int_be(x)
	TAG_Int("state", 1)
	TAG_End()
	totalblocksc++
}