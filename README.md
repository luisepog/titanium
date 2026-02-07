<table>
  <tr>
    <td>
      <img src="lol.png" alt="Titanium icon" width="64" height="64">
    </td>
    <td valign="middle">
      <h1>Titanium</h1>
    </td>
  </tr>
</table>

## Archive Note
> This project is archived. The code was originally written in February 2025<br>
> and is kept here for reference / research purposes only.

In‑app dylib injection with CoreTrust bypass and opainject.<br>
Titanium lets you pick a target process, optionally choose a custom `.dylib`, re‑sign it with a CoreTrust bypass, and inject it into the process on‑device.<br>
Expected to work on iOS versions supported by TrollStore (roughly iOS 14.0 – 17.0) when running with appropriate platform entitlements.<br>

---

## Build
- Uses Theos.
- Clone the repo and run:
```sh
make package
```
- Resulting Titanium.tipa will be placed in packages/.<br>
PRs and improvements are welcome.

### CI / Releases
A GitHub Actions workflow (`.github/workflows/build-and-release.yml`) builds the project and publishes the `.tipa` to **Releases**:
- **On tag push:** Push a tag like `v1.0.0` to trigger a build and create a release with `Titanium.tipa` attached.
- **Manual run:** In the repo go to **Actions → Build and Release → Run workflow** to build and get the artifact (no release is created).

---

## Tested

- Device: iPhone 11 Pro (arm64e)
- Targets: Multiple stock App Store apps
- Notes: Injection tested on real App Store-signed binaries, running on-device via TrollStore with appropriate entitlements.

---

## Credits

- CoreTrust bypass and signing flow based on fastPathSign.
- ROP‑based injection built around opainject.
- Upstream components retain their original licenses.
- Various ideas inspired by the iOS jailbreak / TrollStore community.
- Special thanks to [rain](https://github.com/loxchmorez) for the idea of moving the dylib into the `Application` folder.
<br><br>
Also tagging this troublemaker because he insisted 😏 He cracks good jokes, so he’s here
- [nkhmelni](https://github.com/nkhmelni)  

## License
See [LICENSE](LICENSE).
