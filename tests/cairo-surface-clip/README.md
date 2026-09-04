# Cairo surface clip — visual repro for openfl/openfl#2866

A small OpenFL app that demonstrates two symptoms of the cached Cairo
surface being allowed to exceed the painted region:

1. **Clipping** at the right/bottom edge of a Shape after its bounds
   shrink (Context3D composite path picks up the empty padding).
2. **Reallocation churn** during scale-tween animations when the surface
   is sized to exactly match every frame.

Both rows of the demo animate the same `drawRoundRect` shape; the top
row is rendered through the Cairo cache (`cacheAsBitmap = true`), the
bottom row uses the hardware path for comparison.

A live counter in the corner tracks how many times the Cairo cache
surface was (re)allocated since startup.

## Run

From this directory:

```sh
lime test mac        # or windows / linux
```

Press:

* `space` — toggle between **shrink/grow** cycle and **scale tween** cycle.
* `r` — reset the allocation counter.
* `s` — toggle `cacheAsBitmap` on the top row (forces software path).

## Expected outcomes

| State of the fix | Visible result |
|------------------|----------------|
| Upstream (`>` check + 1.25× margin) | Right/bottom edges of the top shape clip during shrink frames; allocation counter is low during the scale-tween cycle. |
| Exact-fit (current PR head)         | No clipping; allocation counter ticks every frame during scale-tween. |
| High-water / decoupled (proposed)   | No clipping; allocation counter stable after warm-up. |
