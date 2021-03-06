// Copyright (c) 2012, Lukas Renggli <renggli@gmail.com>

/**
 * The basic data structure of any
 */
class Cons {

  /** The head of the cons. */
  Dynamic _head;

  /** The tail of the cons. */
  Dynamic _tail;

  /** Constructs a cons. */
  Cons(this._head, this._tail);

  /** Accessors for the head of this cons. */
  Dynamic get head()             => _head;
          set head(Dynamic head) => _head = head;

  /** Accessors for the tail of this cons. */
  Dynamic get tail()             => _tail;
          set tail(Dynamic tail) => _tail = tail;

  /** Compare the cells. */
  bool operator ==(Cons cons) {
    return cons is Cons && head == cons.head && tail == cons.tail;
  }

  /** Returns the string representation of the cons. */
  String toString() {
    StringBuffer buffer = new StringBuffer();
    buffer.add('(');
    var current = this;
    while (current is Cons) {
      buffer.add(current.head.toString());
      current = current.tail;
      if (current != null) {
        buffer.add(' ');
      }
    }
    if (current != null) {
      buffer.add('. ');
      buffer.add(current);
    }
    buffer.add(')');
    return buffer.toString();
  }

}