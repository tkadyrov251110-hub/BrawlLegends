# Brawl Legends — Godot 4 starter

This is a playable **prototype foundation**, not a finished commercial game. It includes a simple 3D arena, placeholder capsule fighters, basic enemy AI, close-range attacks, score/time HUD, and initial Android/GitHub/Nakama deployment scaffolding.

## Run locally
1. Install Godot 4.3 or newer.
2. Import `project.godot`.
3. Open **Project → Project Settings → Input Map** and add:
   - `move_forward`: W
   - `move_back`: S
   - `move_left`: A
   - `move_right`: D
   - `attack`: left mouse button
4. Press F6/F5 to run. Space also attacks.

## Important next steps
- Replace capsule placeholders with original low-poly/glTF characters and animations.
- Add projectile abilities, health bars, respawns, map themes, sound and mobile touch controls.
- Build proper 3v3/5v5 team logic and match results.
- Configure Nakama authentication, authoritative match handlers, friends/parties, ranks and seasonal data.
- Set Android SDK/JDK and export preset in Godot before expecting the CI workflow to produce an APK.

## Online backend
`server/docker-compose.yml` starts Nakama and PostgreSQL locally. Before production:
- Change all sample credentials and secrets.
- Add Nakama server configuration and authoritative match code.
- Use TLS, firewall rules, backups, rate limiting and moderation.
- Never ship database credentials inside the APK.

## Android export
Create an Android export preset in Godot (`Project → Export`) and commit `export_presets.cfg`. Configure the GitHub repository secret `GODOT_ANDROID_KEYSTORE_DEBUG_PASSWORD` only if your signing workflow requires it. For a release build, use a private keystore and repository secrets; never commit keystore files or passwords.
