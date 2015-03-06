%%%=============================================================================
%%% @copyright (C) 2015, Erlang Solutions Ltd
%%% @author Szymon Mentel <szymon.mentel@erlang-solutions.com>
%%% @doc <Suite purpose>
%%% @end
%%%=============================================================================
-module(dofl_identifier_SUITE).
-copyright("2015, Erlang Solutions Ltd.").

%% Note: This directive should only be used in test suites.
-compile(export_all).
-include_lib("common_test/include/ct.hrl").
-include_lib("eunit/include/eunit.hrl").

-define(TABLE_IDENTIFIER, <<"TableId">>).
-define(DPID, <<"00:00:00:00:00:01:00:01">>).

%%%=============================================================================
%%% Callbacks
%%%=============================================================================


suite() ->
    [{timetrap,{minutes,10}}].

init_per_suite(Config) ->
    mock_dobby(),
    Config.

end_per_suite(_Config) ->
    unmock_dobby(),
    ok.

all() ->
    [should_query_flow_table_id].

%%%=============================================================================
%%% Testcases
%%%=============================================================================

should_query_flow_table_id(_Config) ->
    %% GIVEN
    FlowMod = dofl_test_utils:flow_mod(),
    TableNo = dofl_test_utils:flow_mod_to_table_no(FlowMod),

    %% WHEN
    dofl_identifier:flow_table(?DPID, FlowMod),

    %% THEN
    assert_dobby_search_fun_correct(?DPID, TableNo).

%%%=============================================================================
%%% Internal functions
%%%=============================================================================

mock_dobby() ->
    ok = meck:expect(dby, search, 4, _Ret = ?TABLE_IDENTIFIER).
unmock_dobby() ->
    ok = meck:unload(dby).

assert_dobby_search_fun_correct(Dpid, TableNo) ->
    SearchFun = meck:capture(first, dby, search, 4, _ArgNo = 1),
    Path = [{Dpid,
             internal_metadata([{type, of_switch}]),
             internal_metadata([{type, of_resource}])}],
    SearchResult = SearchFun(?TABLE_IDENTIFIER,
                             internal_metadata([{type, of_flow_table},
                                                {table_no, TableNo}]),
                             Path,
                             []),
    ?assertEqual({stop, ?TABLE_IDENTIFIER}, SearchResult).

internal_metadata(Proplist) ->
    Fun = fun({K, V}, AccMap) ->
                  InnerMap = #{<<"value">> => case is_atom(V) of
                                                  true ->
                                                      atom_to_binary(V, utf8);
                                                  false ->
                                                      V
                                              end,
                               <<"publisher_id">> => <<"ID">>,
                               <<"timestamp">> => <<"TSTM">>},
                  maps:put(atom_to_binary(K, utf8), InnerMap, AccMap)
          end,
    lists:foldl(Fun, #{}, Proplist).


