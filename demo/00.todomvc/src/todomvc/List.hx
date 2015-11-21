package todomvc;

import Doom.*;
import doom.PropertiesComponent;
import thx.ReadonlyArray;

class List extends PropertiesComponent<AppProperties, ListState> {
  override function render()
    return SECTION(["class" => "main"], [
      INPUT([
        "class" => "toggle-all",
        "type" => "checkbox",
        "checked" => state.allCompleted,
        "change" => prop.toggleCheck
      ]),
      LABEL(["for" => "toggle-all"], "Mark all as complete"),
      UL(["class" => "todo-list"], [
        for(item in state.items)
          new Item(prop, { item : item, editing : false })
      ])
    ]);
}

typedef ListState = {
  items : ReadonlyArray<ItemData>,
  allCompleted : Bool
}