%%-------------------------------------------------------------------
%% @doc In memory (global!!) conf using ETS
%% @end
%%-------------------------------------------------------------------
-module(rorrim_conf).

%% ------------------------------------------------------------------
%% Function Exports
%% ------------------------------------------------------------------
-export([new/0, reset/0, to_list/0,
         get/1, set/2, set/1, del/1]).

-type table() :: term().

%% ------------------------------------------------------------------
%% Function Definitions
%% ------------------------------------------------------------------
-spec new() -> Table :: table().
new() ->
    ets:new(?MODULE, [public, named_table, {read_concurrency, true}]).

-spec set(Key::term(), Val::term()) -> true.
set(Key, Value) ->
    ets:insert(?MODULE, {Key, Value}).

-spec set([{Key::term(), Val::term()}]) -> true.
set(KeyValList) ->
    ets:insert(?MODULE, KeyValList).

-spec get(Key::term()) -> Val::term() | error.
get(Key) ->
    case ets:lookup(?MODULE, Key) of
        [] ->
            undefined;
        [{Key, Value}] ->
            Value
    end.

-spec del(Key::term())-> true.
del(Key) ->
    ets:delete(?MODULE, Key).

-spec to_list() -> [{term(), term()}].
to_list() ->
    ets:tab2list(?MODULE).

-spec reset() -> true.
reset() ->
    ets:delete_all_objects(?MODULE).

