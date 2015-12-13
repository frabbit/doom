package doom;

import js.html.Element;
using doom.Patch;
using thx.Strings;

class Component<Api, State> implements IComponent {
  public var element : Element;
  public var node : Node;
  public var api : Api;
  public var state : State;

  public function new(api : Api, state : State) {
    this.api = api;
    this.state = state;
    this.node = render();
  }

  public function init() {
    if(null != element)
      throw new thx.Error('${toString()} has been initialized already');
    element = cast HtmlNode.toHtml(node);
  }

  private function updateNode(oldNode : Node) {
    var newNode = render();
    switch newNode {
      case doom.Node.NodeImpl.Element(_): // do nothing
      case doom.Node.NodeImpl.ComponentNode(_):
      case _: throw new thx.Error('Component ${toString()} must return only element nodes');
    }
    var patches = oldNode.diff(newNode);
    // trace(patches.map(Patches.toString).join("\n"));
    HtmlNode.applyPatches(patches, element);
    node = newNode;
  }

  private function render() : Node
    return throw new thx.error.AbstractMethod();

  public function mount() {}

  public function update(newState : State) {
    var oldState = this.state;
    this.state = newState;
    if(!shouldRender(oldState, newState))
      return;
    updateNode(node);
  }

  public function shouldRender(oldState : State, newState : State)
    return true;

  public function toString() {
    var cls = Type.getClassName(Type.getClass(this)).split(".").pop();
    return '$cls(${node.toString().ellipsisMiddle(80, "...")})';
  }
}
