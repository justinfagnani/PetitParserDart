// Copyright (c) 2012, Lukas Renggli <renggli@gmail.com>

/** Iterable over all parsers reachable from a [root]. */
class ParserIterable implements Iterable<Parser> {

  final Parser _root;

  ParserIterable(this._root);

  ParserIterator iterator() {
    return new ParserIterator(_root);
  }

}

/** Iterator over all parsers reachable from a [root]. */
class ParserIterator implements Iterator<Parser> {

  final List<Parser> _todo;
  final List<Parser> _done;

  ParserIterator(Parser root)
      : _todo = new List.from([root]),
        _done = new List();

  bool hasNext() {
    return !_todo.isEmpty();
  }

  Parser next() {
    if (_todo.isEmpty()) {
      throw const NoMoreElementsException();
    }
    var parser = _todo.removeLast();
    _done.add(parser);
    _todo.addAll(parser.children.filter((each) => _done.indexOf(each) === -1));
    return parser;
  }

}

/** Collection of various common transformations. */
class Transformations {

  /** Pluggable transformation starting at [root]. */
  static Parser transform(Parser root, Parser function(Parser parser)) {
    var sources, targets;
    do {
      sources = new List(); targets = new List();
      var parsers = new List.from(new ParserIterable(root));
      parsers.forEach((source) {
        var target = function(source);
        if (target != null && source !== target) {
          if (source === root) {
            root = target;
          }
          sources.add(source);
          targets.add(target);
        }
      });
      parsers.forEach((parser) {
        for (var i = 0; i < sources.length; i++) {
          parser.replace(sources[i], targets[i]);
        }
      });
    } while (!sources.isEmpty());
    return root;
  }

  /** Removes all wrappers starting at [root]. */
  static Parser removeWrappers(Parser root) {
    // TODO(renggli): replace with exact class check
    return transform(root, (each) => each is WrapperParser ? each.children[0] : each);
  }

}