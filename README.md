# Noctalia Greeter

**_quiet by design_**


<p align="center">
  <img src="https://assets.noctalia.dev/noctalia-logo.svg?v=2" alt="Noctalia Logo" style="width: 192px" />
</p>
 
 
 
 

---

## What is Noctalia Greeter?

A minimal, modern login greeter for [greetd](https://github.com/kennylevinsen/greetd), designed to match the Noctalia look and feel.

It runs as a Wayland client inside [Cage](https://github.com/cage-kiosk/cage), uses the same UI/theming stack as [Noctalia Shell](https://github.com/noctalia-dev/noctalia-shell), and focuses on a clean, reliable authentication flow.

---

## 📋 Requirements

- `greetd`
- `cage`
- `dbus` (`dbus-run-session`)
- A `greeter` system user

Build tools:

- Meson + Ninja
- C++20 compiler
- `pkg-config`
- `just` (optional, but recommended)

Build-time libraries (pkg-config names):

- `wayland-client`, `wayland-protocols`
- `xkbcommon`
- `freetype2`, `fontconfig`
- `cairo`, `cairo-ft`, `pango`, `pangocairo`, `pangoft2`
- `librsvg-2.0`
- `glib-2.0`, `gobject-2.0`, `gio-2.0`
- `egl` / `glesv2` / `wayland-egl` (or `epoxy` fallback)
- `libwebp`

---

## 🚀 Getting Started

### 1) Build

```bash
meson setup build
meson compile -C build
```

or:

```bash
just build
```

### 2) Install

```bash
just install
```

This installs the greeter binary and session launcher, then runs system setup:

- `scripts/setup_greetd_pam.sh`
- `scripts/setup_greeter_system.sh`

### 3) Configure greetd

Add this to `/etc/greetd/config.toml`:

```toml
[default_session]
command = "/usr/local/bin/noctalia-greeter-session"
user = "greeter"
```

If your install prefix is different, use the installed path for `noctalia-greeter-session`.

### 4) Restart greetd

```bash
sudo systemctl restart greetd
# or
sudo sv restart greetd
```

---

## Development

Run locally under Cage:

```bash
just run-local
```

Run inside an existing Wayland session:

```bash
just run-niri
```

AddressSanitizer:

```bash
just run-cage-asan
```

Recovery helper:

```bash
just recover
```

---

## Scope

Noctalia Greeter is a **display/login greeter** for greetd. It handles user/session selection and authentication UI.

It is **not** a desktop shell or compositor replacement.

---

## 🤝 Contributing

Contributions are welcome: fixes, polish, docs, or UX improvements.

- Open an issue for bugs and regressions
- Open a PR for improvements

---

## 📄 License

MIT License.

