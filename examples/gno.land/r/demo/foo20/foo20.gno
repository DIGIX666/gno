// foo20 is a GRC20 token contract where all the grc20.Teller methods are
// proxified with top-level functions. see also gno.land/r/demo/bar20.
package foo20

import (
	"std"
	"strings"

	"gno.land/p/demo/grc/grc20"
	"gno.land/p/demo/ownable"
	"gno.land/p/demo/ufmt"
	pusers "gno.land/p/demo/users"
	"gno.land/r/demo/grc20reg"
	"gno.land/r/demo/users"
)

var (
	Token, privateLedger = grc20.NewToken("Foo", "FOO", 4)
	UserTeller           = Token.CallerTeller()
	Ownable              = ownable.NewWithAddress("g1manfred47kzduec920z88wfr64ylksmdcedlf5") // @manfred
)

func init() {
	privateLedger.Mint(Ownable.Owner(), 1_000_000*10_000) // @privateLedgeristrator (1M)
	grc20reg.Register(Token.Getter(), "")
}

func TotalSupply() uint64 {
	return UserTeller.TotalSupply()
}

func BalanceOf(owner pusers.AddressOrName) uint64 {
	ownerAddr := users.Resolve(owner)
	return UserTeller.BalanceOf(ownerAddr)
}

func Allowance(owner, spender pusers.AddressOrName) uint64 {
	ownerAddr := users.Resolve(owner)
	spenderAddr := users.Resolve(spender)
	return UserTeller.Allowance(ownerAddr, spenderAddr)
}

func Transfer(to pusers.AddressOrName, amount uint64) {
	toAddr := users.Resolve(to)
	checkErr(UserTeller.Transfer(toAddr, amount))
}

func Approve(spender pusers.AddressOrName, amount uint64) {
	spenderAddr := users.Resolve(spender)
	checkErr(UserTeller.Approve(spenderAddr, amount))
}

func TransferFrom(from, to pusers.AddressOrName, amount uint64) {
	fromAddr := users.Resolve(from)
	toAddr := users.Resolve(to)
	checkErr(UserTeller.TransferFrom(fromAddr, toAddr, amount))
}

// Faucet is distributing foo20 tokens without restriction (unsafe).
// For a real token faucet, you should take care of setting limits are asking payment.
func Faucet() {
	caller := std.PrevRealm().Addr()
	amount := uint64(1_000 * 10_000) // 1k
	checkErr(privateLedger.Mint(caller, amount))
}

func Mint(to pusers.AddressOrName, amount uint64) {
	Ownable.AssertCallerIsOwner()
	toAddr := users.Resolve(to)
	checkErr(privateLedger.Mint(toAddr, amount))
}

func Burn(from pusers.AddressOrName, amount uint64) {
	Ownable.AssertCallerIsOwner()
	fromAddr := users.Resolve(from)
	checkErr(privateLedger.Burn(fromAddr, amount))
}

func Render(path string) string {
	parts := strings.Split(path, "/")
	c := len(parts)

	switch {
	case path == "":
		return Token.RenderHome()
	case c == 2 && parts[0] == "balance":
		owner := pusers.AddressOrName(parts[1])
		ownerAddr := users.Resolve(owner)
		balance := UserTeller.BalanceOf(ownerAddr)
		return ufmt.Sprintf("%d\n", balance)
	default:
		return "404\n"
	}
}

func checkErr(err error) {
	if err != nil {
		panic(err)
	}
}
