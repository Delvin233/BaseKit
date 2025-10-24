#  BaseKit — 5-Day Development Plan

###  Project Overview

**BaseKit** is a multi-engine Web3 gaming SDK that allows developers to add **wallet login and Base Name identity** directly into their games. **Currently optimized for Godot Engine** with plans to expand to Unity, Unreal Engine, and other popular game engines.  
It enables "Sign in with Base" functionality using **Base Names**, making Web3 access seamless for both players and developers.

---

##  Development Timeline (Extended Sprint)

### **Day 1 — Project Setup & Basic UI**

- [ ] Set up Godot project structure (GDScript)
- [ ] Create basic UI scenes and layouts
- [ ] Design "Connect Wallet" button and styling
- [ ] Test basic `HTTPRequest` node functionality
- [ ] Create mock wallet address display
- [ ] Set up project folders and initial scripts

**Goal:** Clean project structure with working UI foundation.

**Deliverable:** Godot project with clickable UI that shows mock data.

---

### **Day 2 — RPC Connection & Wallet Logic**

- [ ] Implement Base RPC calls using `HTTPRequest`
- [ ] Handle JSON responses and error cases
- [ ] Create wallet address validation
- [ ] **Fallback:** Mock wallet connection if RPC issues
- [ ] Log all network activity for debugging
- [ ] Test with multiple RPC endpoints

**Goal:** Reliable connection to Base network with proper error handling.

**Backup Plan:** Use hardcoded test addresses if network issues persist.

---

### **Day 3 — Base Name Resolution**

- [ ] Research ENS resolution on Base network
- [ ] Implement Base Name lookup functionality
- [ ] Handle reverse resolution (address → name)
- [ ] Add avatar metadata fetching
- [ ] Create fallback for addresses without Base Names
- [ ] Cache resolution results locally

**Goal:** Convert wallet addresses to human-readable Base Names.

**Test Data:** Use known addresses with confirmed Base Names.

---

### **Day 4 — Game Development Day! 🎮**

**Joint Task - Build Coin Adventure Game Together**

**Morning: Game Design (2-3 hours)**

- [ ] Study platformer game mechanics (jump, collect coins, platforms)
- [ ] Plan BaseKit integration (show Base Name as player name)
- [ ] Design sprites (knight character, coins, platforms, enemies)
- [ ] Set up game scene structure in examples/ folder

**Afternoon: Game Implementation (4-5 hours)**

- [ ] Create player character with jump and movement physics
- [ ] Add platform collision and coin collection mechanics
- [ ] Implement enemy AI and collision detection
- [ ] Add scoring system tied to Base Name
- [ ] Integrate BaseKit login for score display

**BaseKit Integration:**

- Show Base Name in high score display
- "Sign in with Base" to save scores
- Display avatar next to player name
- Leaderboard with Base Names instead of "Anonymous"

**Goal:** Playable Coin Adventure game with Web3 identity integration.

---

### **Day 5 — Polish, Testing & Documentation**

**Joint Task**

**Morning: Integration & Polish**

- [ ] Combine all BaseKit components
- [ ] Add session persistence and error handling
- [ ] Polish game UI and BaseKit integration
- [ ] Test full flow: login → play → persist

**Afternoon: Documentation & Demo**

- [ ] Write clear README with setup instructions
- [ ] Create developer documentation
- [ ] Record 60-second demo video
- [ ] Package SDK for distribution
- [ ] Test on different devices/platforms

**Goal:** Complete, documented SDK with impressive game demo.

---

##  Game Development Learning Path

### **Godot Basics (Day 4 Morning)**

- Scenes and nodes structure
- GDScript fundamentals
- Input handling
- Basic physics and movement

### **Game Integration Ideas**

```gdscript
# Example: Show Base Name in game UI
func _ready():
    if BaseKit.is_connected():
        player_name_label.text = BaseKit.get_base_name()
        avatar_texture.texture = BaseKit.get_avatar()
```

### **Coin Adventure Game Mechanics**

**Core Gameplay:**

- Player controls a knight character on platforms
- Player uses arrow keys to move and space to jump
- Score increases by collecting coins scattered on platforms
- Avoid slime enemies that patrol platforms
- Platformer-style physics with gravity and jumping

**BaseKit Integration:**

```gdscript
# Show Base Name in UI
func update_player_display():
    if BaseKit.is_connected():
        player_label.text = BaseKit.get_base_name()
        high_score_label.text = "Best: " + str(get_high_score())
    else:
        player_label.text = "Anonymous Player"
```

**Game Features:**

- **Main Menu:** "Sign in with Base" button
- **Game Over:** Show current score + Base Name
- **High Scores:** Leaderboard with Base Names
- **Simple Graphics:** Colorful pixel art style

---

##  Tech Stack

| Component           | Tool                                   |
| ------------------- | -------------------------------------- |
| **Engine**          | Godot 4.x                              |
| **Language**        | GDScript                               |
| **Blockchain**      | Base Network (EVM-compatible)          |
| **RPC Endpoint**    | `https://mainnet.base.org` (primary)   |
| **Backup RPC**      | `https://base.llamarpc.com` (fallback) |
| **ENS Resolution**  | Base ENS Registry + IPFS gateways      |
| **Version Control** | Git + GitHub                           |
| **Game Assets**     | Free assets from Godot Asset Library   |

---

##  Repository Structure

```
base-kit-godot-sdk/
│
├── basekit/                     # SDK Core
│   ├── wallet_connector.gd      # RPC calls
│   ├── basename_resolver.gd     # ENS lookups
│   ├── session_manager.gd       # Persistence
│   ├── basekit_manager.gd       # Main API
│   └── config.gd                # Settings
│
├── ui/                          # SDK UI Components
│   ├── login_panel.tscn
│   ├── profile_display.tscn
│   └── login_panel.gd
│
├── coin_adventure/              # Coin Adventure Game!
│   ├── scenes/
│   │   ├── main_menu.tscn       # Login + start game
│   │   ├── game_scene.tscn      # Main gameplay
│   │   ├── game_over.tscn       # Score + restart
│   │   └── leaderboard.tscn     # High scores
│   ├── scripts/
│   │   ├── player.gd            # Movement physics
│   │   ├── coin_spawner.gd      # Coin generation
│   │   ├── obstacle_spawner.gd  # Obstacle generation
│   │   └── score_manager.gd     # Points + BaseKit
│   └── assets/
│       ├── player_sprite.png    # Simple pixel character
│       ├── coin_sprite.png      # Coin graphics
│       ├── obstacle_sprite.png  # Obstacle graphics
│       └── collect_sound.wav    # Audio feedback
│
├── examples/                    # SDK Usage Examples
│   ├── simple_login.gd
│   └── integration_guide.md
│
└── docs/
    ├── API_REFERENCE.md
    └── GAME_INTEGRATION.md
```

---

##  Collaboration Workflow

**Daily Structure:**

- **Morning standup** (15 min): What did you do? What's next? Any blockers?
- **Afternoon check-in** (10 min): Progress update and help needed
- **End of day** (5 min): Commit code and update plan

**Git Workflow:**

```bash
# Daily routine
git checkout main
git pull origin main
git checkout -b feature/day-X-task
# ... work on feature ...
git add .
git commit -m "Day X: Added [feature]"
git push origin feature/day-X-task
# Create PR for review
```

---

##  Success Criteria by Day

### **Day 1 Success:**

- [ ] Godot project opens without errors
- [ ] UI buttons are clickable and styled
- [ ] Basic project structure is in place

### **Day 2 Success:**

- [ ] Can make HTTP requests to Base RPC
- [ ] Wallet address displays in UI (real or mock)
- [ ] Error handling works for network failures

### **Day 3 Success:**

- [ ] Base Name resolution works for test addresses
- [ ] Avatar loading with fallback image
- [ ] Caching system stores results

### **Day 4 Success:**

- [ ] Player moves and collects coins
- [ ] Coin and obstacle spawning works
- [ ] Score system tracks collected coins
- [ ] BaseKit shows Base Name in game UI
- [ ] Game over screen displays final score + Base Name

### **Day 5 Success:**

- [ ] Complete SDK package ready for distribution
- [ ] Demo video showcasing game + BaseKit
- [ ] Documentation for other developers

---

##  Learning Objectives

**Technical Skills:**

- GDScript programming
- HTTP requests and JSON handling
- Game development fundamentals
- UI/UX design in Godot
- Web3 integration patterns

**Soft Skills:**

- Collaborative development
- Project planning and execution
- Problem-solving under time constraints
- Documentation writing
- Demo presentation

---

##  Risk Mitigation

| Day | Risk                       | Solution                          |
| --- | -------------------------- | --------------------------------- |
| 1   | Godot setup issues         | Use online Godot editor as backup |
| 2   | RPC connection fails       | Switch to mock data immediately   |
| 3   | ENS resolution complex     | Use hardcoded test mappings       |
| 4   | Game mechanics too complex | Focus on jump + collision only    |
| 5   | Integration breaks         | Focus on documentation over fixes |

---

##  Game Development Resources

**Free Assets:**

- [Kenney.nl](https://kenney.nl) - Free game assets
- [OpenGameArt.org](https://opengameart.org) - Community assets
- [Freesound.org](https://freesound.org) - Sound effects

**Godot Learning:**

- [Official Godot Docs](https://docs.godotengine.org)
- [GDScript Basics](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_basics.html)
- [Your First 2D Game](https://docs.godotengine.org/en/stable/getting_started/first_2d_game/index.html)

---

##  Final Deliverables

**Code:**

- [ ] BaseKit SDK (ready for other developers)
- [ ] Custom demo game showcasing integration
- [ ] Example scripts and tutorials

**Documentation:**

- [ ] API reference for BaseKit
- [ ] Game integration guide
- [ ] Setup instructions for developers

**Media:**

- [ ] 60-second demo video
- [ ] Screenshots of game + BaseKit
- [ ] GIFs showing login flow

**Bonus:**

- [ ] Exported game builds (desktop/web)
- [ ] Blog post about the development process
- [ ] Presentation slides for demo day

---

> **BaseKit** — Learn game dev while building the future of Web3 gaming!
