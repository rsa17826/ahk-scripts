class collision {
  static collides(p1, p2) {
    return p1.x <= p2.x + p2.w &&
      p1.x + p1.w >= p2.x &&
      p1.y <= p2.y + p2.h &&
      p1.y + p1.h >= p2.y
  }
  class point {
    __New(x, y) {
      this.x := x
      this.y := y
      this.w := 0
      this.h := 0
    }
  }
  class rect {
    __New(x, y, w, h) {
      this.x := x
      this.y := y
      this.w := w
      this.h := h
    }
  }
}

; p1 := collision.point(0, 0)
; p2 := collision.point(0.001, 0)
; print(collision.collides(p1, p2))
