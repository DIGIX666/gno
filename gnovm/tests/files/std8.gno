package main

import (
	"std"

	"gno.land/p/demo/testutils"
)

func inner() {
	realm1 := std.CurrentRealm()
	println(realm1)
	realm2 := std.PreviousRealm()
	println(realm2)
}

func main() {
	testutils.WrapCall(inner)
}

// Output:
// (struct{("g17rgsdnfxzza0sdfsdma37sdwxagsz378833ca4" std.Address),("main" string)} std.Realm)
// (struct{("g1wymu47drhr0kuq2098m792lytgtj2nyx77yrsm" std.Address),("" string)} std.Realm)



// Stacktrace:
//



// Error:
// frame not found
