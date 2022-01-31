-module(compare_tests).
-include_lib("eunit/include/eunit.hrl").

create_test_()-> 
    [
    ?_assert(compare_test:test(1,10) =:= ok),
    ?_assert(compare_test:test(100,100) =:= ok),
    ?_assert(compare_test:test(1000,1000) =:= ok),
    ?_assert(compare_test:test(-1,-1) =:= "Improper input amount"),
    ?_assertError(badarith,compare_test:test("text","text"))
    ].
