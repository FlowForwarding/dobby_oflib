%%%=============================================================================
%%% @copyright (C) 2015, Erlang Solutions Ltd
%%% @author Szymon Mentel <szymon.mentel@erlang-solutions.com>
%%% @doc <Module purpose>
%%% @end
%%%=============================================================================
-module(dobby_ofclient).
-copyright("2015, Erlang Solutions Ltd.").

%% API
-export([get_path/2]).

%% Application callbacks
-export([]).

%% -include_lib("").
%% -include("").

%% -define(MYMAC, "MY").

%%------------------------------------------------------------------------------
%% Types
%%------------------------------------------------------------------------------

%% -record(some_rec, {id :: string()}).

%%%=============================================================================
%%% Callbacks
%%%=============================================================================

%%%=============================================================================
%%% External functions
%%%=============================================================================

-spec get_path(SrcEndpoint :: binary(), DstEndpoint :: binary()) ->
                      {ok, Path :: digraph:graph()} | {error, Reason :: term()}.

get_path(SrcEndPoint, DstEndpoint) ->
    {ok, digraph:new()}.

%%%=============================================================================
%%% Internal functions
%%%=============================================================================