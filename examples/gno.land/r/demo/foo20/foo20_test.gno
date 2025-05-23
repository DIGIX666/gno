package foo20

import (
	"std"
	"testing"

	"gno.land/p/demo/testutils"
	"gno.land/p/demo/uassert"
)

func TestReadOnlyPublicMethods(t *testing.T) {
	var (
		admin = std.Address("g1manfred47kzduec920z88wfr64ylksmdcedlf5")
		alice = testutils.TestAddress("alice")
		bob   = testutils.TestAddress("bob")
	)

	type test struct {
		name    string
		balance uint64
		fn      func() uint64
	}

	// check balances #1.
	{
		tests := []test{
			{"TotalSupply", 10_000_000_000, func() uint64 { return TotalSupply() }},
			{"BalanceOf(admin)", 10_000_000_000, func() uint64 { return BalanceOf(admin) }},
			{"BalanceOf(alice)", 0, func() uint64 { return BalanceOf(alice) }},
			{"Allowance(admin, alice)", 0, func() uint64 { return Allowance(admin, alice) }},
			{"BalanceOf(bob)", 0, func() uint64 { return BalanceOf(bob) }},
		}
		for _, tc := range tests {
			got := tc.fn()
			uassert.Equal(t, got, tc.balance)
		}
	}

	// bob uses the faucet.
	testing.SetOriginCaller(bob)
	cross(Faucet)()

	// check balances #2.
	{
		tests := []test{
			{"TotalSupply", 10_010_000_000, func() uint64 { return TotalSupply() }},
			{"BalanceOf(admin)", 10_000_000_000, func() uint64 { return BalanceOf(admin) }},
			{"BalanceOf(alice)", 0, func() uint64 { return BalanceOf(alice) }},
			{"Allowance(admin, alice)", 0, func() uint64 { return Allowance(admin, alice) }},
			{"BalanceOf(bob)", 10_000_000, func() uint64 { return BalanceOf(bob) }},
		}
		for _, tc := range tests {
			got := tc.fn()
			uassert.Equal(t, got, tc.balance)
		}
	}
}

func TestErrConditions(t *testing.T) {
	var (
		admin = std.Address("g1manfred47kzduec920z88wfr64ylksmdcedlf5")
		empty = std.Address("")
	)

	type test struct {
		name string
		msg  string
		fn   func()
	}

	privateLedger.Mint(std.Address(admin), 10000)
	{
		tests := []test{
			{"Transfer(admin, 1)", "cannot send transfer to self", func() {
				// XXX: should replace with: Transfer(admin, 1)
				// but there is currently a limitation in manipulating the frame stack and simulate
				// calling this package from an outside point of view.
				adminAddr := std.Address(admin)
				if err := privateLedger.Transfer(adminAddr, adminAddr, 1); err != nil {
					panic(err)
				}
			}},
			{"Approve(empty, 1))", "invalid address", func() { cross(Approve)(empty, 1) }},
		}
		for _, tc := range tests {
			t.Run(tc.name, func(t *testing.T) {
				uassert.PanicsWithMessage(t, tc.msg, tc.fn)
			})
		}
	}
}
