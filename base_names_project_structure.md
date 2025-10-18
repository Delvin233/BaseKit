# Base Names Login Kit - Complete Project Structure

## 📋 Project Overview
**Goal:** Create a Unity SDK that enables seamless Web3 identity and login for games on Base using Base Names (ENS on Base).

**Core Value Proposition:** Allow Unity game developers to integrate wallet-based authentication with human-readable Base Names instead of complex addresses.

---

## 🎯 Day 1: Ideation & Scoping

### Morning (2-3 hours)
**Problem Definition**
- Current state: Players use wallet addresses (0x1234...) - not user-friendly
- Pain point: No standard identity layer for Unity games on Base
- Solution: Login kit that displays Base Names (e.g., "player.base.eth")

**User Journey Mapping**
1. Player opens Unity game
2. Clicks "Connect with Base"
3. Wallet connection popup appears (mobile/desktop)
4. After connection, game displays Base Name + avatar
5. Player identity persists across sessions

### Afternoon (3-4 hours)
**Feature Definition**

**MVP Features (Must Have):**
- Wallet connection (WalletConnect or Web3Auth)
- Fetch Base Name from connected address
- Display Base Name in-game
- Retrieve and display avatar (if set)
- Session persistence

**Stretch Goals (Nice to Have):**
- Cross-game identity profile
- On-chain leaderboards by Base Name
- NFT badge minting
- Web2 fallback (email login with wallet creation)

**Mockups & Design**
- Login button design
- Connected state UI (name + avatar display)
- Profile card component
- Error states (no wallet, no Base Name)

**Deliverable:** Problem/solution essay (1-2 pages) + UI mockups

---

## 🏗️ Day 2: Architecture & Setup

### Project Structure
```
BaseNamesLoginKit/
├── Assets/
│   ├── BaseAuth/
│   │   ├── Scripts/
│   │   │   ├── Core/
│   │   │   │   ├── BaseAuthManager.cs
│   │   │   │   ├── WalletConnector.cs
│   │   │   │   ├── BaseNameResolver.cs
│   │   │   │   └── SessionManager.cs
│   │   │   ├── Models/
│   │   │   │   ├── PlayerProfile.cs
│   │   │   │   └── BaseNameData.cs
│   │   │   └── Utils/
│   │   │       ├── Web3Helper.cs
│   │   │       └── AvatarLoader.cs
│   │   ├── Prefabs/
│   │   │   ├── BaseLoginButton.prefab
│   │   │   └── PlayerProfileCard.prefab
│   │   └── UI/
│   │       └── Sprites/
│   ├── Demo/
│   │   ├── Scenes/
│   │   │   └── DemoGame.unity
│   │   └── Scripts/
│   │       └── DemoGameManager.cs
│   └── Plugins/
│       └── [Third-party SDKs]
├── Packages/
│   └── manifest.json
└── README.md
```

### Technical Setup

**Dependencies to Install:**
- Nethereum (Ethereum library for Unity)
- UnityWebRequest or alternative HTTP client
- WalletConnect Unity SDK OR Web3Auth Unity SDK
- JSON parsing library (Newtonsoft.Json)

**Configuration:**
```csharp
// BaseAuthConfig.cs
public class BaseAuthConfig
{
    public const string BASE_RPC_URL = "https://mainnet.base.org";
    public const string BASE_NAME_REGISTRY = "0x..."; // ENS registry on Base
    public const int BASE_CHAIN_ID = 8453;
}
```

### Key Components to Build

**1. BaseAuthManager.cs** (Singleton)
```
Methods:
- InitializeAuth()
- ConnectWallet()
- DisconnectWallet()
- GetConnectedAddress()
- IsAuthenticated()
Events:
- OnWalletConnected
- OnWalletDisconnected
- OnBaseNameResolved
```

**2. WalletConnector.cs**
```
Methods:
- OpenWalletSelection()
- ConnectViaWalletConnect()
- ConnectViaWeb3Auth()
- GetWalletAddress()
```

**3. BaseNameResolver.cs**
```
Methods:
- ResolveBaseName(address)
- GetAvatar(baseName)
- ReverseResolve(baseName)
```

**4. SessionManager.cs**
```
Methods:
- SaveSession(address, baseName)
- LoadSession()
- ClearSession()
- IsSessionValid()
```

**Deliverable:** Working Unity project with mock login button that logs connection

---

## 💻 Day 3: Wallet Connection

### Morning: WalletConnect Integration
- Set up WalletConnect project ID
- Implement wallet selection UI
- Handle QR code generation (desktop)
- Handle deep linking (mobile)
- Test connection flow

### Afternoon: Address Retrieval & Session
- Get wallet address after connection
- Store address securely
- Implement session persistence (PlayerPrefs/file)
- Add disconnect functionality
- Error handling for connection failures

### Testing Checklist
- [ ] Desktop wallet connection works
- [ ] Mobile wallet connection works
- [ ] Address retrieves correctly
- [ ] Session persists on restart
- [ ] Disconnect clears session

**Deliverable:** Functional wallet connection returning address

---

## 🔗 Day 4: Base Name Integration

### Morning: Base Name Resolution
- Connect to Base RPC endpoint
- Query ENS registry for reverse resolution
- Implement BaseNameResolver with Nethereum
- Handle cases where no Base Name exists
- Cache resolved names

### Afternoon: Avatar Retrieval
- Query avatar text record from ENS
- Parse IPFS/HTTP URLs
- Download and display avatar image
- Implement fallback for missing avatars
- Create Unity Sprite from downloaded image

### Data Models
```csharp
public class PlayerProfile
{
    public string WalletAddress;
    public string BaseName;
    public Sprite Avatar;
    public DateTime LastLogin;
}
```

### Testing Checklist
- [ ] Base Name resolves from address
- [ ] Avatar loads correctly
- [ ] Fallback works (no name/avatar)
- [ ] Profile displays in UI

**Deliverable:** Complete login flow showing Base Name + avatar

---

## 🎮 Day 5: Demo Game Integration

### Demo Game Concept
**Type:** Simple endless runner or clicker game

**Integration Points:**
1. Main menu with "Connect with Base" button
2. Player profile display (top corner)
3. Score tracking tied to Base Name
4. Simple in-game interaction

### Implementation
- Create demo scene with basic gameplay
- Add BaseAuth prefab to scene
- Display connected Base Name during gameplay
- Optional: Mint achievement NFT on milestone

### Scene Flow
```
MainMenu Scene
├── BaseLoginButton
└── [On Connect Success] → Load GameScene

GameScene
├── PlayerProfileUI (shows Base Name + Avatar)
├── GameplayCanvas
└── ScoreManager (tracks score by Base Name)
```

**Deliverable:** Playable demo + 60-90 second screen recording

---

## 📚 Day 6: Polish & Documentation

### Morning: Documentation
**README.md Structure:**
```markdown
# Base Names Login Kit

## Problem
[2-3 sentences on identity in Web3 games]

## Solution
[How this SDK solves it]

## Features
- Wallet connection
- Base Name resolution
- Avatar display
- Session management

## Installation
1. Import package
2. Add prefab to scene
3. Configure settings

## Quick Start
[Code example]

## API Reference
[Key methods and events]

## Demo
[Link to video]

## License
MIT
```

### Afternoon: Final Polish
- Clean up code comments
- Remove debug logs
- Test on multiple devices
- Package SDK as .unitypackage
- Create branding assets (logo, banner)
- Record final demo video

### Demo Video Script (90 seconds)
1. **Opening (10s):** Problem statement
2. **SDK Demo (30s):** Show installation and setup
3. **Game Demo (40s):** Show working integration
4. **Closing (10s):** Benefits and call-to-action

**Deliverable:** Submission-ready repository + demo video

---

## 🚀 Day 7: Submission & Stretch Goals

### Morning: Final Submission
- Push final code to GitHub
- Write submission form entries
- Prepare pitch deck (if required)
- Test all links and downloads

### Afternoon: Stretch Features (if time permits)
**Priority Order:**
1. **On-chain player profiles** - Store game stats on Base
2. **Leaderboard system** - Query and display top players by Base Name
3. **Unity Editor tool** - Verify Base Name ownership in editor
4. **Web2 fallback** - Email login that creates embedded wallet

---

## 🛠️ Technical Architecture

### Authentication Flow
```
User clicks "Connect"
    ↓
Open WalletConnect modal
    ↓
User approves in wallet
    ↓
Retrieve wallet address
    ↓
Query Base Name from address
    ↓
Fetch avatar metadata
    ↓
Store session locally
    ↓
Display profile in game
```

### Data Flow
```
BaseAuthManager (Singleton)
    ↓
WalletConnector → Gets address
    ↓
BaseNameResolver → Gets name + avatar
    ↓
SessionManager → Saves session
    ↓
UI Components → Display data
```

---

## 📦 Deliverables Checklist

### Code
- [ ] Unity package (.unitypackage)
- [ ] Source code on GitHub
- [ ] Demo game scene
- [ ] Example scripts

### Documentation
- [ ] README with setup instructions
- [ ] API documentation
- [ ] Code comments
- [ ] License file

### Media
- [ ] Demo video (60-90s)
- [ ] Screenshots
- [ ] UI mockups
- [ ] Project logo

### Optional
- [ ] Pitch deck
- [ ] Technical diagram
- [ ] Blog post write-up

---

## 🎯 Success Criteria

**MVP Success:**
- User can connect wallet in Unity game
- Base Name displays after connection
- Avatar shows (or fallback)
- Session persists

**Bonus Points:**
- Clean, reusable SDK
- Excellent documentation
- Polished demo game
- Creative stretch features

---

## 🔧 Development Tips

1. **Start Simple:** Get wallet connection working first before Base Name
2. **Mock Data:** Use test addresses with known Base Names for development
3. **Error Handling:** Plan for users without Base Names
4. **Performance:** Cache resolved names to avoid repeated RPC calls
5. **Security:** Never store private keys, only addresses
6. **Cross-platform:** Test on Windows, Mac, Android, iOS if possible

---

## 📞 Resources & References

- Base RPC Documentation
- Base Names (ENS) Documentation
- WalletConnect Unity SDK
- Nethereum Documentation
- Unity UI Best Practices

---

## Timeline at a Glance

| Day | Focus | Key Milestone |
|-----|-------|---------------|
| 1 | Planning | Problem defined, features scoped |
| 2 | Setup | Unity project skeleton complete |
| 3 | Wallet | Wallet connection working |
| 4 | Base Names | Name + avatar resolution |
| 5 | Demo | Playable game with integration |
| 6 | Polish | Documentation + video |
| 7 | Submit | Final submission ready |