package crossrealm

import (
	"gno.land/p/demo/tests/p_crossrealm"
	"gno.land/p/demo/ufmt"
)

type LocalStruct struct {
	A int
}

func (ls *LocalStruct) String() string {
	return ufmt.Sprintf("LocalStruct{%d}", ls.A)
}

// local is saved locally in this realm
var local *LocalStruct

func init() {
	local = &LocalStruct{A: 123}
}

// Make1 returns a local object wrapped by a p struct
func Make1() *p_crossrealm.Container {
	return &p_crossrealm.Container{
		A: 1,
		B: local,
	}
}

type Fooer interface{ Foo() }

var fooer Fooer

func SetFooer(f Fooer) Fooer {
	fooer = f
	return fooer
}

func GetFooer() Fooer { return fooer }

func CallFooerFoo() { fooer.Foo() }

type FooerGetter func() Fooer

var fooerGetter FooerGetter

func SetFooerGetter(fg FooerGetter) FooerGetter {
	fooerGetter = fg
	return fg
}

func GetFooerGetter() FooerGetter {
	return fooerGetter
}

func CallFooerGetterFoo() { fooerGetter().Foo() }
