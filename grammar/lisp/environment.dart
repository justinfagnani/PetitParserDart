// Copyright (c) 2012, Lukas Renggli <renggli@gmail.com>

/** Abstract enviornment of bindings. */
abstract class Environment {

  /** The internal environment bindings. */
  final Map<Symbol, Dynamic> _bindings;

  /** Constructor for the environment. */
  Environment() : _bindings = new Map();

  /** Constructor for a nested environment. */
  Environment create() => new NestedEnvironment(this);

  /** Returns the value defined by a [key]. */
  Dynamic operator [](Symbol key) {
    return _bindings.containsKey(key)
        ? _bindings[key]
        : _notFound(key);
  }

  /** Defines or redefines the cell with [value] of a [key]. */
  void operator []=(Symbol key, Dynamic value) {
    _bindings[key] = value;
  }

  /** Returns the keys of the bindings. */
  Collection<Symbol> get keys() => _bindings.getKeys();

  /** Returns the parent of the bindings. */
  Environment get parent() => null;

  /** Called when a missing binding is accessed. */
  abstract Dynamic _notFound(Symbol key);

}

/** The root environment of the execution. */
class RootEnvironment extends Environment {

  /** Return null if the value does not exist. */
  _notFound(Symbol key) => null;

  /** Register the minimal functions needed for bootstrap. */
  RootEnvironment() {

    /** Defines a value in the root environment. */
    _define('define', (Environment env, Dynamic args) {
      if (args.head is Cons) {
        var definition = new Cons(args.head.tail, args.tail);
        return this[args.head.head] = Natives.find('lambda')(env, definition);
      } else {
        return this[args.head] = eval(env, args.tail.head);
      }
    });

    /** Lookup a native function. */
    _define('native', (Environment env, Dynamic args) {
      return Natives.find(args.head);
    });

    /** Defines all native functions. */
    _define('native-import-all', (Environment env, Dynamic args) {
      return Natives.importAllInto(this);
    });

  }

  /** Private function to define primitives. */
  _define(String key, Dynamic cell) {
    this[new Symbol(key)] = cell;
  }

}

/** The default execution environment with a parent. */
class NestedEnvironment extends Environment {

  /** The owning environemnt. */
  final Environment _owner;

  /** Constructs a nested environment. */
  NestedEnvironment(this._owner);

  /** Returns the parent of the bindings. */
  Environment get parent() => _owner;

  /** Lookup values in the parent environment. */
  _notFound(Symbol key) => _owner[key];

}