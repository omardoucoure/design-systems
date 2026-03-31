// ═══════════════════════════════════════════════════════════════════════════════
// DS Builders — Deterministic component builders for Figma
// Rules are code, not prose. Each builder enforces ALL component rules automatically.
// This file is self-contained — paste it as a preamble in figma_execute calls.
// ═══════════════════════════════════════════════════════════════════════════════

const DSBuilders = {

  // ─── COLOR TOKENS (from design system theme) ──────────────────────────────
  COLORS: {
    surfaceNeutral0_5:  { r: 250/255, g: 250/255, b: 249/255 },  // white/cream
    surfaceNeutral2:    { r: 235/255, g: 235/255, b: 230/255 },  // light grey
    surfacePrimary100:  { r: 70/255,  g: 90/255,  b: 84/255  },  // dark green
    surfacePrimary120:  { r: 37/255,  g: 47/255,  b: 44/255  },  // darkest green
    surfaceSecondary100:{ r: 255/255, g: 106/255, b: 95/255  },  // coral
    textNeutral9:       { r: 41/255,  g: 41/255,  b: 39/255  },  // dark text
    textNeutral0_5:     { r: 250/255, g: 250/255, b: 249/255 },  // light text
  },

  // ─── FIGMA PAGE IDS (never search for pages again) ───────────────────────
  PAGES: {
    Cover:        '0:1',
    Tokens:       '6:52',
    Components:   '78:91',
    Icons:        '80:1077',
    PageExemples: '85:32937',
    OurStorybook: '90:168805',
    Demo:         '125:49648',
    FUTEvolution: '129:71388',
  },

  // ─── COMPONENT SET IDS (parent sets — use for findAll, searching) ───────
  SETS: {
    InputsFilled:       '85:22930',
    InputsLined:        '85:23305',
    Button:             '85:23697',
    Checkbox:           '85:24367',
    Radio:              '85:24408',
    Toggle:             '85:24435',
    Tooltip:            '85:24455',
    TopAppBar:          '85:24922',
    BottomAppBar:       '85:25779',
    SegmentedPicker:    '85:25956',
    NavTab:             '85:25996',
    PageControls:       '85:26004',
    Keyboard:           '85:26092',
    List:               '85:26304',
    LeadingItem:        '85:27094',
    TrailingItem:       '85:27135',
    InteractionState:   '85:27183',
    Avatar:             '85:27173',
    ProgressCircle:     '85:27190',
    Divider:            '85:27242',
    BadgesTags:         '85:31357',
    ChatBubble:         '87:95924',
    ChatInputBar:       '87:95530',
    ProductCard:        '87:96055',
    ProductDetailHero:  '87:96135',
    FeedPostCard:       '87:96262',
    LikeCommentRow:     '87:96325',
    ToastAlert:         '87:95277',
    FullScreenAlertCard:'87:100899',
    DialogAlert:        '87:100926',
    PhotoGrid:          '87:96819',
    ProfileHeroCard:    '87:97036',
    StatsRow:           '87:98042',
    MonthCalendarGrid:  '87:99455',
    WeekDayStrip:       '87:99567',
    DayTimeline:        '87:99677',
    DateRangeBar:       '87:99691',
    TimeArc:            '87:99717',
    EventCard:          '87:99855',
    CartItemRow:        '87:100080',
    CartSummaryFooter:  '87:100098',
    CheckoutStepper:    '87:100203',
    CameraControlsBar:  '87:100709',
    PhotoEditToolbar:   '87:100817',
    SideMenu:           '87:104255',
    MediaPlayer:        '87:107645',
    StatsChartCard:     '87:118703',
    LayeredCard:        '88:137815',
    OverlappingCards:   '88:152411',
  },

  // ─── COMPONENT VARIANT IDS (direct instantiation — no searching) ────────
  IDS: {
    // Inputs-Filled
    inputFilledEmpty:     '85:22931',
    inputFilledFilled:    '85:22942',
    inputFilledActive:    '85:22953',
    inputFilledError:     '85:22964',
    inputFilledValidated: '85:22975',
    inputFilledDropdown:  '85:22986',
    inputFilledTextarea:  '85:23053',
    // Inputs-Lined
    inputLinedEmpty:      '85:23306',
    inputLinedFilled:     '85:23317',
    inputLinedActive:     '85:23328',
    inputLinedError:      '85:23339',
    inputLinedValidated:  '85:23350',
    // Button — Style_Size_State
    buttonFilledABig:     '85:23698',
    buttonNeutralBig:     '85:23702',
    buttonFilledBBig:     '85:23706',
    buttonFilledCBig:     '85:23710',
    buttonOutlinedBig:    '85:23830',
    buttonTextBig:        '85:23834',
    buttonFilledAMedium:  '85:23746',
    buttonNeutralMedium:  '85:23750',
    buttonFilledBMedium:  '85:23762',
    buttonFilledCMedium:  '85:23782',
    buttonOutlinedMedium: '85:23866',
    buttonTextMedium:     '85:23870',
    buttonFilledASmall:   '85:23794',
    buttonNeutralSmall:   '85:23798',
    buttonFilledBSmall:   '85:23810',
    buttonFilledCSmall:   '85:23842',
    buttonOutlinedSmall:  '85:23890',
    buttonTextSmall:      '85:23894',
    // Checkbox (small — correct variant from set 85:24849)
    checkboxSet:          '85:24849',
    checkboxUnchecked:    '85:24850',
    checkboxIntermediate: '85:24853',
    checkboxChecked:      '85:24858',
    // Radio
    radioFalse:           '85:24409',
    radioTrue:            '85:24412',
    // Toggle
    toggleFalse:          '85:24436',
    toggleTrue:           '85:24442',
    // Top App Bar
    topAppBarStatus:      '85:24923',
    topAppBarLogo:        '85:24937',
    topAppBarSmall:       '85:24941',
    topAppBarSmallImage:  '85:24945',
    topAppBarImageBtn:    '85:24949',
    topAppBarSmallIcons:  '85:24954',
    topAppBarSearch:      '85:24962',
    topAppBarMediumIcons: '85:24968',
    topAppBarLargeIcons:  '85:24977',
    topAppBarHomeIndicator:'85:24986',
    // Bottom App Bar
    bottomAppBarFull:     '85:25780',
    bottomAppBarFloating: '85:25791',
    bottomAppBarMore:     '85:25801',
    // Segmented Picker
    pickerTabs:           '85:25957',
    pickerPills:          '85:25962',
    // Avatar
    avatarMonogram:       '85:27174',
    avatarIcon:           '85:27176',
    avatarImage:          '85:27178',
    // Progress-Circle
    progress10:           '85:27191',
    progress50:           '85:27211',
    progress80:           '85:27226',
    progress100:          '85:27236',
    // Divider
    dividerFullBleed:     '85:27243',
    dividerInset:         '85:27245',
    dividerMiddle:        '85:27247',
    dividerSubheader:     '85:27249',
    // Badges-Tags
    badgeDot:             '85:31358',
    badgeNumberBrand:     '85:31359',
    tagBrand:             '85:31363',
    // Container Card (standalone component, not in a set)
    containerCard:        '88:137854',
    // Layered Card
    layeredBottom2:       '88:137809',
    layeredBottom1:       '88:137810',
    layeredTop2:          '88:137811',
    layeredTop1:          '88:137812',
    // Overlapping Cards
    overlapping2Small:    '88:152405',
    overlapping2Medium:   '88:152406',
    overlapping3Small:    '88:152408',
    overlapping5Small:    '88:152410',
    // Profile Hero Card
    profileHeroLight:     '87:96960',
    profileHeroDark:      '87:96981',
    profileHeroCover:     '87:96999',
    profileHeroCoral:     '87:97017',
    // Feed Post Card
    feedPostImage:        '87:96260',
    feedPostText:         '87:96261',
    feedPostPodcast:      '87:96471',
    // Stats Chart Card (most used)
    statsLollipop:        '87:117765',
    statsLineLight:       '87:117833',
    statsLineDark:        '87:117870',
    statsGauge:           '87:117942',
    statsArea:            '87:118002',
    statsMetricDark:      '87:118128',
    statsMetricCoral:     '87:118137',
    // Side Menu (most used)
    sideMenuIconGrid:     '87:103862',
    sideMenuListSearch:   '87:103886',
    sideMenuSidebar:      '87:103912',
    sideMenuDarkCoral:    '87:104178',
    // Media Player
    mediaVinyl:           '87:107335',
    mediaFullDark:        '87:107435',
    mediaCarousel:        '87:107462',
    // Calendar
    calendarLight:        '87:98909',
    calendarCoral:        '87:99086',
    weekStripPills:       '87:99565',
    weekStripCompact:     '87:99566',
    // Alerts
    toastWarning:         '87:95272',
    toastSuccess:         '87:95273',
    toastInfo:            '87:95274',
    toastError:           '87:95278',
    dialogWarning:        '87:100924',
    dialogDark:           '87:100925',
    // Shopping
    productCardGrid:      '87:96053',
    productCardHoriz:     '87:96054',
    // Brand logo
    logoBrand:            '85:24762',
    // Frequently swapped icons
    iconMailOpen:         '85:33084',
    iconEyeClosed:        '85:33088',
    iconGoogle:           '85:34182',
    iconFacebook:         '85:35004',
    iconX:                '85:35009',
    // Picker tab inner button variants (for swapping active/inactive)
    btnFilledCSmall:      '85:23842',
    btnNeutralSmall:      '85:23798',
  },

  // ─── SHARED UTILITIES ─────────────────────────────────────────────────────

  /** Walk parent tree, return nearest solid fill color or null */
  getParentFill(node) {
    let current = node.parent;
    while (current) {
      if (current.fills && current.fills.length > 0 && current.fills[0].type === 'SOLID') {
        return current.fills[0].color;
      }
      current = current.parent;
    }
    return null;
  },

  /** Check if two RGB colors match within tolerance (0-255 scale) */
  colorsMatch(a, b, tolerance = 5) {
    if (!a || !b) return false;
    return Math.abs(a.r * 255 - b.r * 255) <= tolerance
        && Math.abs(a.g * 255 - b.g * 255) <= tolerance
        && Math.abs(a.b * 255 - b.b * 255) <= tolerance;
  },

  /** Check if a background color needs light foreground (dark bg) */
  needsLightFg(bg) {
    if (!bg) return false;
    return bg.r * 255 < 100;
  },

  /** Check if a fill matches a specific token */
  fillIsToken(node, token) {
    if (!node || !node.fills || node.fills.length === 0) return false;
    const fill = node.fills[0];
    if (fill.type !== 'SOLID') return false;
    return this.colorsMatch(fill.color, this.COLORS[token]);
  },

  /** Set solid fill on a node */
  setFill(node, colorOrToken) {
    const color = typeof colorOrToken === 'string' ? this.COLORS[colorOrToken] : colorOrToken;
    node.fills = [{ type: 'SOLID', color }];
  },

  /** Find a child by name within an instance */
  findChild(instance, name, type) {
    return instance.findOne(n => n.name === name && (!type || n.type === type));
  },

  /** Load DM Sans fonts (call once per figma_execute) */
  async loadFonts() {
    await figma.loadFontAsync({ family: "DM Sans", style: "Medium" });
    await figma.loadFontAsync({ family: "DM Sans", style: "SemiBold" });
  },

  // ─── PAGE NAVIGATION (instant — no searching) ────────────────────────────

  /** Switch to a page by key (e.g., 'Demo', 'Components'). Returns the page node. */
  async goToPage(pageKey) {
    const pageId = this.PAGES[pageKey];
    if (!pageId) throw new Error(`Unknown page key: ${pageKey}. Available: ${Object.keys(this.PAGES).join(', ')}`);
    const page = await figma.getNodeByIdAsync(pageId);
    if (!page) throw new Error(`Page ${pageKey} (${pageId}) not found in file`);
    await figma.setCurrentPageAsync(page);
    return page;
  },

  /** Get a component by its IDS key (e.g., 'buttonFilledABig'). Returns the component node. */
  async getComponent(idsKey) {
    const nodeId = this.IDS[idsKey];
    if (!nodeId) throw new Error(`Unknown IDS key: ${idsKey}. Check DSBuilders.IDS`);
    const node = await figma.getNodeByIdAsync(nodeId);
    if (!node) throw new Error(`Component ${idsKey} (${nodeId}) not found`);
    return node;
  },

  /** Instantiate a component by its IDS key, append to parent, set FILL width. */
  async instantiate(parent, idsKey, name) {
    const comp = await this.getComponent(idsKey);
    const inst = comp.createInstance();
    if (name) inst.name = name;
    parent.appendChild(inst);
    inst.layoutSizingHorizontal = 'FILL';
    return inst;
  },

  // ─── SCREEN FRAME ─────────────────────────────────────────────────────────

  /** Create a standard 393×852 screen frame with correct padding */
  screenFrame(parent, props = {}) {
    const screen = figma.createFrame();
    screen.name = props.name || 'Screen';
    screen.resize(props.width || 393, props.height || 852);
    this.setFill(screen, 'surfaceNeutral0_5');
    screen.layoutMode = 'VERTICAL';
    screen.counterAxisAlignItems = 'MIN';
    screen.primaryAxisSizingMode = 'FIXED';
    screen.paddingLeft = 12;
    screen.paddingRight = 12;
    screen.paddingTop = 0;
    screen.paddingBottom = 12;
    screen.itemSpacing = 12;
    screen.clipsContent = true;
    if (parent) parent.appendChild(screen);
    return screen;
  },

  // ─── STATUS BAR ───────────────────────────────────────────────────────────

  async statusBar(parent) {
    const comp = await figma.getNodeByIdAsync(this.IDS.topAppBarStatus);
    const inst = comp.createInstance();
    parent.appendChild(inst);
    inst.layoutSizingHorizontal = 'FILL';
    return inst;
  },

  // ─── CONTAINER CARD ───────────────────────────────────────────────────────

  /**
   * Create a Container Card. Instantiates the component, configures slots,
   * then detaches if extraChildren are needed.
   * @param {object} props - { name, fill?, slots?, detach? }
   * @param {object} props.slots - { title?, subtitle?, showInput1?, showInput2?, showCheckbox?, showCTA?, showFooter?, footerText? }
   */
  async containerCard(parent, props = {}) {
    const comp = await figma.getNodeByIdAsync(this.IDS.containerCard);
    const inst = comp.createInstance();
    parent.appendChild(inst);
    inst.layoutSizingHorizontal = 'FILL';

    // Configure built-in slot properties
    const slotProps = {};
    if (props.slots) {
      const s = props.slots;
      if (s.title) slotProps['Title#100:21'] = s.title;
      if (s.subtitle !== undefined) {
        slotProps['Show Subtitle#100:22'] = !!s.subtitle;
        if (s.subtitle) slotProps['Subtitle Text#100:23'] = s.subtitle;
      }
      if (s.showInput1 !== undefined) slotProps['Show Input 1#100:24'] = s.showInput1;
      if (s.showInput2 !== undefined) slotProps['Show Input 2#100:25'] = s.showInput2;
      if (s.showCheckbox !== undefined) slotProps['Show Checkbox#100:26'] = s.showCheckbox;
      if (s.showCTA !== undefined) slotProps['Show CTA#100:27'] = s.showCTA;
      if (s.showFooter !== undefined) {
        slotProps['Show Footer#100:28'] = !!s.showFooter;
        if (s.footerText) slotProps['Footer Text#100:29'] = s.footerText;
      }
    }
    if (Object.keys(slotProps).length > 0) inst.setProperties(slotProps);

    // Override fill if specified
    let result = inst;
    if (props.fill || props.detach) {
      result = inst.detachInstance();
      result.name = props.name || 'Card';
      if (props.fill) {
        const color = typeof props.fill === 'string' ? this.COLORS[props.fill] : props.fill;
        this.setFill(result, color);
      }
      // Remove unused hidden children if detached for custom content
      if (props.removeHiddenSlots) {
        const toRemove = [];
        for (const child of result.children) {
          if (!child.visible) toRemove.push(child);
        }
        for (const child of toRemove) child.remove();
      }
    } else {
      inst.name = props.name || 'Card';
    }

    return result;
  },

  // ─── CHECKBOX ─────────────────────────────────────────────────────────────
  // Rules enforced:
  //   checkbox_correct_variant: ALWAYS uses 85:24849 (small set), never 85:24367
  //   checkbox_stroke_fix: ALWAYS sets strokeAlign = INSIDE on inner frame

  async checkbox(parent, props = {}) {
    // Rule: checkbox_correct_variant — use correct component set
    const variantId = props.checked ? this.IDS.checkboxChecked : this.IDS.checkboxUnchecked;
    const comp = await figma.getNodeByIdAsync(variantId);
    const inst = comp.createInstance();
    parent.appendChild(inst);

    // Rule: checkbox_stroke_fix — fix stroke overflow
    const cbFrame = this.findChild(inst, 'Checkbox', 'FRAME');
    if (cbFrame) cbFrame.strokeAlign = 'INSIDE';

    // Set label text
    if (props.label) {
      const texts = inst.findAll(n => n.type === 'TEXT');
      for (const t of texts) {
        await figma.loadFontAsync(t.fontName);
        t.characters = props.label;
      }
    }

    return inst;
  },

  // ─── SEGMENTED PICKER ─────────────────────────────────────────────────────
  // Rules enforced:
  //   picker_bg_contrast: container bg must contrast with parent card
  //   picker_unselected_match: inactive tabs match container bg
  //   picker_hide_segments: hide Show 3/4 when items <= 2

  async segmentedPicker(parent, props = {}) {
    // Rule: picker_bg_contrast — auto-detect style from parent bg
    const parentFill = this.getParentFill({ parent });
    const parentIsSurfaceNeutral2 = parentFill && this.colorsMatch(parentFill, this.COLORS.surfaceNeutral2);

    // If inside a surfaceNeutral2 card, use tabs style (white container)
    // Otherwise use pills style (grey container)
    const styleId = parentIsSurfaceNeutral2 ? this.IDS.pickerTabs : this.IDS.pickerPills;
    const comp = await figma.getNodeByIdAsync(styleId);
    const inst = comp.createInstance();
    parent.appendChild(inst);
    inst.layoutSizingHorizontal = 'FILL';

    // Rule: picker_bg_contrast — set container fill to contrast with parent
    if (parentIsSurfaceNeutral2) {
      this.setFill(inst, 'surfaceNeutral0_5');
    }

    // Rule: picker_hide_segments — hide unused segments
    const items = props.items || [];
    if (items.length <= 2) {
      inst.setProperties({ 'Show 3#157:4': false, 'Show 4#157:5': false });
    } else if (items.length <= 3) {
      inst.setProperties({ 'Show 4#157:5': false });
    }

    // Set tab labels and swap active/inactive variants
    const visibleTabs = inst.findAll(n => n.type === 'INSTANCE' && n.name === 'Button' && n.visible);
    const selectedIndex = props.selectedIndex || 0;

    for (let i = 0; i < visibleTabs.length && i < items.length; i++) {
      const tab = visibleTabs[i];
      const isSelected = (i === selectedIndex);

      // Swap to correct variant
      const targetComp = await figma.getNodeByIdAsync(
        isSelected ? this.IDS.btnFilledCSmall : this.IDS.btnNeutralSmall
      );
      tab.swapComponent(targetComp);

      // Set text
      const textNode = tab.findOne(n => n.type === 'TEXT' && n.visible);
      if (textNode) {
        await figma.loadFontAsync(textNode.fontName);
        textNode.characters = items[i];
        // Rule: selected tab text = light, unselected = dark
        if (isSelected) {
          textNode.fills = [{ type: 'SOLID', color: this.COLORS.textNeutral0_5 }];
        }
      }

      // Rule: picker_unselected_match — inactive tab fill matches picker container
      if (!isSelected && parentIsSurfaceNeutral2) {
        tab.fills = [{ type: 'SOLID', color: this.COLORS.surfaceNeutral0_5 }];
      }
    }

    return inst;
  },

  // ─── BUTTON ───────────────────────────────────────────────────────────────
  // Rules enforced:
  //   button_icon_contrast: filledB/C/outlinedLight need light icon fills

  async button(parent, props = {}) {
    // Map style+size to node ID (complete matrix)
    const s = props.style || 'filledA';
    const sz = props.size || 'big';
    const styleMap = {
      filledA:  { big: this.IDS.buttonFilledABig,  medium: this.IDS.buttonFilledAMedium,  small: this.IDS.buttonFilledASmall },
      filledB:  { big: this.IDS.buttonFilledBBig,  medium: this.IDS.buttonFilledBMedium,  small: this.IDS.buttonFilledBSmall },
      filledC:  { big: this.IDS.buttonFilledCBig,  medium: this.IDS.buttonFilledCMedium,  small: this.IDS.buttonFilledCSmall },
      neutral:  { big: this.IDS.buttonNeutralBig,  medium: this.IDS.buttonNeutralMedium,  small: this.IDS.buttonNeutralSmall },
      outlined: { big: this.IDS.buttonOutlinedBig,  medium: this.IDS.buttonOutlinedMedium, small: this.IDS.buttonOutlinedSmall },
      text:     { big: this.IDS.buttonTextBig,      medium: this.IDS.buttonTextMedium,     small: this.IDS.buttonTextSmall },
    };
    const nodeId = styleMap[s]?.[sz] || this.IDS.buttonFilledABig;

    const comp = await figma.getNodeByIdAsync(nodeId);
    const inst = comp.createInstance();
    parent.appendChild(inst);

    if (props.fullWidth) inst.layoutSizingHorizontal = 'FILL';
    if (props.grow) inst.layoutGrow = 1;

    // Set properties
    const setProps = {};
    if (props.label) {
      setProps['Text#115:9'] = true;
      setProps['Button-Text#104:0'] = props.label;
    } else {
      setProps['Text#115:9'] = false;
    }
    setProps['Icon Right#115:34'] = !!props.iconRight;
    setProps['Icon Left#115:31'] = !!props.iconLeft;
    if (props.iconRightId) setProps['Icon-Right#115:37'] = props.iconRightId;
    if (props.iconLeftId) setProps['Icon-Left#115:40'] = props.iconLeftId;
    inst.setProperties(setProps);

    // Rule: button_icon_contrast — fix icon color on dark button styles
    const darkStyles = ['filledB', 'filledC', 'outlinedLight'];
    if (darkStyles.includes(props.style)) {
      const iconSlots = inst.findAll(n => n.type === 'INSTANCE' && n.visible);
      for (const icon of iconSlots) {
        if (icon.parent && (icon.parent.name.includes('Right') || icon.parent.name.includes('Left'))) {
          const vectors = icon.findAll(n => n.type === 'VECTOR' || n.type === 'BOOLEAN_OPERATION');
          for (const v of vectors) {
            v.fills = [{ type: 'SOLID', color: this.COLORS.textNeutral0_5 }];
          }
        }
      }
    }

    return inst;
  },

  // ─── TEXT FIELD ────────────────────────────────────────────────────────────
  // Rules enforced:
  //   textfield_bg_contrast: input bg = surfaceNeutral0_5 when inside surfaceNeutral2 card

  async textField(parent, props = {}) {
    // Use Filled state if value provided, else Empty
    const nodeId = props.value ? this.IDS.inputFilledFilled : this.IDS.inputFilledEmpty;
    const comp = await figma.getNodeByIdAsync(nodeId);
    const inst = comp.createInstance();
    parent.appendChild(inst);
    inst.layoutSizingHorizontal = 'FILL';

    // Set component properties
    const setProps = {
      'Icon Right#159:3': !!props.icon,
      'Icon Left#159:9': false,
      'Helper Text#159:12': false,
      'Button#192:10': false,
    };
    // Icon swap
    if (props.icon) {
      const iconMap = {
        'mail-open': this.IDS.iconMailOpen,
        'eye-closed': this.IDS.iconEyeClosed,
      };
      const iconId = iconMap[props.icon] || props.icon;
      setProps['Icon Right#159:0'] = iconId;
    }
    inst.setProperties(setProps);

    // Set label and value text
    const textNodes = inst.findAll(n => n.type === 'TEXT' && n.name === 'Text' && n.parent?.name === 'Text');
    for (const t of textNodes) {
      await figma.loadFontAsync(t.fontName);
    }
    if (textNodes[0] && props.label) textNodes[0].characters = props.label;
    if (textNodes[1] && props.value) textNodes[1].characters = props.value;

    // Rule: textfield_bg_contrast — override input bg when inside surfaceNeutral2 card
    const parentFill = this.getParentFill(inst);
    if (parentFill && this.colorsMatch(parentFill, this.COLORS.surfaceNeutral2)) {
      const inputFrame = this.findChild(inst, 'Input', 'FRAME');
      if (inputFrame) {
        this.setFill(inputFrame, 'surfaceNeutral0_5');
      }
    }

    return inst;
  },

  // ─── HELPER: Create a text node ───────────────────────────────────────────

  text(parent, props = {}) {
    const t = figma.createText();
    t.fontName = { family: "DM Sans", style: props.weight || "Medium" };
    t.fontSize = props.size || 16;
    t.characters = props.text || '';
    const color = props.color ? (typeof props.color === 'string' ? this.COLORS[props.color] : props.color) : this.COLORS.textNeutral9;
    t.fills = [{ type: 'SOLID', color }];
    if (props.opacity !== undefined) t.opacity = props.opacity;
    if (props.align) t.textAlignHorizontal = props.align;
    parent.appendChild(t);
    t.layoutSizingHorizontal = props.fillWidth !== false ? 'FILL' : 'HUG';
    return t;
  },

  // ─── HELPER: Create a horizontal row frame ────────────────────────────────

  row(parent, props = {}) {
    const f = figma.createFrame();
    f.name = props.name || 'Row';
    f.layoutMode = 'HORIZONTAL';
    f.counterAxisAlignItems = props.align || 'CENTER';
    f.primaryAxisAlignItems = props.justify || 'SPACE_BETWEEN';
    f.itemSpacing = props.gap || 0;
    f.fills = [];
    parent.appendChild(f);
    f.layoutSizingHorizontal = 'FILL';
    f.primaryAxisSizingMode = 'AUTO';
    f.counterAxisSizingMode = 'AUTO';
    return f;
  },

};
