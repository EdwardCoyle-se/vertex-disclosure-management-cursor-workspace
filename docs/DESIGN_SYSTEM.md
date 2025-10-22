# Vertex Design System - Quartz SB Guidelines

> **Purpose**: Complete design system guidelines for implementing consistent Vertex UI components following Schneider Electric's "Quartz SB" design language.

## 🎨 Design System Overview

The Framework Management Platform follows Schneider Electric's **"Quartz SB"** design language, emphasizing sustainability, technology, and professional excellence. These guidelines ensure consistent user experience across all platform interfaces.

---

## 🔧 **5.4. Design System Guidelines (Quartz SB)**

### **Brand Identity & Visual Language**

- Design system follows Schneider Electric's "Quartz SB" platform design language
- Emphasizes sustainability, technology, and professional excellence
- Maintains brand consistency across all user touchpoints and interactions

### **Color System Hierarchy**

**CRITICAL:** When implementing UI components, ALWAYS follow this hierarchy:

1. **Quartz Palette** (FIRST PRIORITY) - From `vertex-ui-shared/styles/quartz.css`
2. **Vertex Palette** (SECOND PRIORITY) - From `vertex-ui-shared/styles/styles.css`
3. **Custom Colors** (LAST RESORT) - Only after consulting with design team

### **Color Palette**

All colors should be referenced using CSS variables for theme consistency and maintainability.

#### *Primary Colors (Quartz):*

- **Primary Green:** `var(--qgreen-inv)` or `bg-qgreen-inv` - Used for primary actions, success states, and brand accents
- **Deep Green:** `var(--qgreen-800)` or `bg-qgreen-800` - Used for backgrounds and high-contrast text  
- **Forest Green:** `var(--qgreen-600)` or `bg-qgreen-600` - Used for secondary elements and hover states
- **Medium Green:** `var(--qgreen-500)` or `bg-qgreen-500` - Used for standard green elements
- **Light Green:** `var(--qgreen-400)` or `bg-qgreen-400` - Used for lighter green accents

#### *Supporting Colors (Quartz):*

- **Ocean Blue:** `var(--qblue-500)` or `bg-qblue-500` - Used for information and secondary actions
- **Purple Accent:** `var(--qpurple-500)` or `bg-qpurple-500` - Used sparingly for highlights and special indicators
- **Orange Warning:** `var(--qorange-500)` or `bg-qorange-500` - Used for warnings and caution states
- **Error Red:** `var(--qred-500)` or `bg-qred-500` - Used for errors and destructive actions

#### *Neutral Colors (Quartz):*

- **Backgrounds:** `var(--qgray-50)` (lightest), `var(--qneutral-100)`, `var(--qneutral-200)` (cards/sections)
- **Text Primary:** `var(--qgray-950)` or `text-qgray-950` - High contrast text
- **Text Secondary:** `var(--qgray-600)` or `text-qgray-600` - Muted text
- **Borders:** `var(--qgray-200)` or `border-qgray-200` - Subtle borders
- **Gray Scale:** Available from `--qgray-50` through `--qgray-950` (50, 100, 200, 250, 300, 400, 500, 550, 600, 700, 800, 900, 950)

### **Typography Standards**

#### *Font Family:*

- **Primary:** Nunito Sans (for body text, UI elements)
- **Display:** Nunito (for headings, large text)

#### *Font Hierarchy:*

- **H1 (Page Headers):** 2xl (28px), medium weight
- **H2 (Section Headers):** xl (20px), medium weight
- **H3 (Subsection Headers):** lg (18px), medium weight  
- **H4 (Component Headers):** base (14px), medium weight
- **Body Text:** base (14px), normal weight
- **Small Text:** sm (12px), normal weight

#### *Font Weights:*

- **Normal:** 400 (body text, descriptions)
- **Medium:** 500 (headings, labels, buttons)
- **Semibold:** 600 (large headings only)

### **Layout & Spacing System**

#### *Container Patterns:*

- **Page Container:** `container mx-auto px-6 py-8` (max-width with horizontal padding)
- **Card Spacing:** `p-6` for content cards
- **Section Spacing:** `mb-8` between major sections, `mb-6` between subsections
- **Control Spacing:** `gap-3` between related controls, `gap-6` between control groups

#### *Grid System:*

- Use CSS Grid for complex layouts
- Use Flexbox for simple component layouts
- Maintain 8px base spacing unit (multiples of 8: 8, 16, 24, 32, 48, 64px)

### **Component Design Standards**

#### *Buttons:*

- **Primary:** Filled with `bg-qgreen-inv`, white text, used for main actions
- **Secondary:** Outlined with primary color, transparent background
- **Tertiary:** Text-only with `text-qblue-500`, minimal emphasis
- **Sizes:** Small (`size="sm"`), Default, Large for different contexts
- Always include proper loading and disabled states
- Use `hover:bg-qgreen-600` for primary button hovers

#### *Cards:*

- Use `bg-qgray-50` with `border border-qgray-200` and `rounded-lg`
- Apply subtle shadows: `shadow-sm` for most cards
- Maintain `p-6` internal padding for content
- Use `space-y-4` for internal element spacing

#### *Tables & Lists:*

- Zebra striping using `even:bg-qneutral-100`
- Hover states using `hover:bg-qgreen-100` for row interactions
- Consistent column padding with `px-4 py-2`
- Header styling with `font-medium text-qgray-600`

#### *Forms & Inputs:*

- Use `bg-qneutral-100` for input field backgrounds
- Label styling: `font-medium text-qgray-700` with proper spacing
- Group related inputs with consistent spacing
- Provide clear validation feedback with `border-qred-500` for errors

#### *Status Indicators:*

- **Published/Success:** Use `text-qgreen-inv` or `bg-qgreen-100`
- **Draft/Pending:** Use `text-qgray-600` or `bg-qgray-200`
- **Warning:** Use `text-qorange-500` or `bg-qorange-100`
- **Error:** Use `text-qred-500` or `bg-qred-100`

#### *Navigation & Hierarchy:*

- Tree indentation: 24px increments per level
- Expand/collapse icons: Use lucide-react icons consistently
- Breadcrumbs: Use `text-qgray-600` with proper separators
- Active states: Use `bg-qgreen-100 border-qgreen-500` for active items

### **Interactive States & Hover System**

#### *Hover System for Brand Consistency:*

- **Interactive Buttons:** Use `hover:bg-qgreen-600` for primary buttons
- **Standard Rows:** Use `hover:bg-qgreen-100` for table row interactions
- **Subtle Interactions:** Use `hover:bg-qneutral-100` for minimal hover feedback
- **Links:** Use `text-qblue-500 hover:underline` for clickable links
- **Transitions:** Always include `transition-colors duration-200` for smooth interactions
- **Focus States:** Use `focus:outline focus:outline-qfocus-500` for keyboard navigation

### **Implementation Guidelines**

#### *Development Best Practices:*

- Use vertex-ui-shared components as the primary UI library following established patterns
- Implement responsive layouts using CSS Grid and Flexbox as defined in component standards
- Maintain code modularity with shared components and utilities in separate files
- Follow established spacing patterns using the 8px grid system for consistency

#### *Brand Consistency:*

- Apply Quartz SB color palette consistently across all user interfaces
- ALWAYS use CSS variables from Quartz palette first (e.g., `var(--qgreen-inv)` or `bg-qgreen-inv`)
- Use designated hover states and interaction patterns for unified user experience
- Implement proper typography hierarchy with specified font families and weights
- Maintain visual consistency with established component design standards

#### *Color Hierarchy in Practice:*

1. **Check Quartz First**: Look in `vertex-ui-shared/styles/quartz.css` for available colors
2. **Check Vertex Second**: If Quartz doesn't have what you need, check `vertex-ui-shared/styles/styles.css`
3. **Consult Design Team**: Only create custom colors after consulting with design team
4. **Use CSS Variables**: Never hardcode hex values - always use `var(--qcolor-name)` or Tailwind classes like `bg-qcolor-name`

---

## 🚨 **Critical Implementation Rules**

### **MANDATORY Requirements for Vertex UI Implementation:**

1. **🎨 Use Quartz SB Design System**: All UI components MUST follow the color palette, typography, and spacing guidelines above
2. **🔧 vertex-ui-shared First**: Always use `@se-sustainability-business/vertex-ui-shared` components when available
3. **🎯 Color Hierarchy**: ALWAYS use Quartz colors first → Vertex colors second → Custom colors only as last resort
4. **🎨 CSS Variables Only**: NEVER use hardcoded hex colors - use CSS variables (e.g., `var(--qgreen-inv)` or `bg-qgreen-inv`)
5. **🎭 Consistent Hover States**: Implement the hover system for all interactive elements
6. **📐 8px Grid System**: All spacing and layout MUST use multiples of 8px
7. **🔤 Typography Hierarchy**: Follow the specified font hierarchy and weights

### **Color Usage Examples:**

```css
/* Primary Actions - Use Quartz CSS Variables */
.btn-primary {
  background-color: var(--qgreen-inv);
  color: white;
}

.btn-primary:hover {
  background-color: var(--qgreen-600);
}

/* Hover States - Use Quartz palette */
.row-hover {
  background-color: var(--qgreen-100); /* Light green for row hovers */
}

.subtle-hover {
  background-color: var(--qneutral-100); /* Neutral for subtle hovers */
}

/* Status Indicators - Use Quartz colors */
.status-success { color: var(--qgreen-inv); }
.status-warning { color: var(--qorange-500); }
.status-info { color: var(--qblue-500); }
.status-error { color: var(--qred-500); }

/* Text Colors - Use Quartz gray scale */
.text-primary { color: var(--qgray-950); }
.text-secondary { color: var(--qgray-600); }
.text-muted { color: var(--qgray-500); }
```

### **Typography Usage Examples:**

```css
/* Font Families - Use from vertex-ui-shared */
.font-primary { font-family: var(--font-sans); }
.font-display { font-family: var(--font-sans); }

/* Typography Scale - Use Tailwind utilities */
.text-h1 { @apply text-2xl font-medium; } /* 28px, medium */
.text-h2 { @apply text-xl font-medium; } /* 20px, medium */
.text-body { @apply text-base font-normal; } /* 14px, normal */
```

### **TailwindCSS with Quartz Colors:**

```html
<!-- ✅ CORRECT - Use Quartz Tailwind classes -->
<div class="bg-qgreen-inv text-white hover:bg-qgreen-600">Primary Button</div>
<div class="bg-qgray-50 border border-qgray-200 rounded-lg">Card</div>
<p class="text-qgray-950">Primary Text</p>
<p class="text-qgray-600">Secondary Text</p>

<!-- ❌ WRONG - Never use hardcoded hex colors -->
<div class="bg-[#3DCD58] hover:bg-[#005C1E]">Don't do this!</div>
```

---

## 📚 **Integration with vertex-ui-shared**

When implementing components, always check vertex-ui-shared first:

```typescript
// ✅ CORRECT - Use vertex-ui-shared components with Quartz colors
import { VertexButton } from '@se-sustainability-business/vertex-ui-shared/button';
import { VertexCard } from '@se-sustainability-business/vertex-ui-shared/card';
import { VertexTable } from '@se-sustainability-business/vertex-ui-shared/table';
import { TranslatePipe } from '@se-sustainability-business/vertex-ui-shared/translate';

// Apply Quartz styling with CSS variables
<VertexButton 
  variant="primary" 
  className="bg-qgreen-inv hover:bg-qgreen-600 transition-colors duration-200"
>
  {{ 'action.save' | translate }}
</VertexButton>

// ❌ WRONG - Never hardcode hex colors
<VertexButton className="bg-[#3DCD58]">Don't do this!</VertexButton>
```

---

## 🔗 **References**

- **Storybook Reference**: <https://vertex-components-non.sb.se.com>
- **vertex-ui-shared Documentation**: Check component library for latest patterns
- **TailwindCSS**: Used for utility classes following 8px grid system
- **Lucide React**: Icon library for consistent iconography

---

## 🎨 **Complete Quartz Color Reference** (updated 2025-10-22)

### Available Quartz Colors (from `vertex-ui-shared/styles/quartz.css`)

**Green Palette:**
- `--qgreen-inv` / `bg-qgreen-inv` - Primary green for actions (#3dcd58 light mode, #008029 dark mode)
- `--qgreen-100` / `bg-qgreen-100` - Light green background (#e3f8e7)
- `--qgreen-400` / `bg-qgreen-400` - Medium green (#009530)
- `--qgreen-500` / `bg-qgreen-500` - Standard green (#008029)
- `--qgreen-600` / `bg-qgreen-600` - Forest green (#005c1e)
- `--qgreen-800` / `bg-qgreen-800` - Deep green (#003310)

**Blue Palette:**
- `--qblue-100` / `bg-qblue-100` - Light blue background (#dbf5ff)
- `--qblue-500` / `bg-qblue-500` - Ocean blue (#0075a3)
- `--qblue-600` / `bg-qblue-600` - Dark blue (#005c80)
- `--qblue-800` / `bg-qblue-800` - Deep blue (#00374d)

**Purple Palette:**
- `--qpurple-500` / `bg-qpurple-500` - Accent purple (#7524bf)
- `--qpurple-600` / `bg-qpurple-600` - Dark purple (#5c1c96)
- `--qpurple-800` / `bg-qpurple-800` - Deep purple (#351056)

**Orange Palette:**
- `--qorange-100` / `bg-qorange-100` - Light orange background (#ffefdb)
- `--qorange-500` / `bg-qorange-500` - Warning orange (#a35b00)

**Red Palette:**
- `--qred-100` / `bg-qred-100` - Light red background (#ffdfdb)
- `--qred-500` / `bg-qred-500` - Error red (#cc1300)
- `--qred-600` / `bg-qred-600` - Dark red (#a30f00)
- `--qred-800` / `bg-qred-800` - Deep red (#660a00)

**Gray Scale:**
- `--qgray-50` / `bg-qgray-50` - Lightest background (#fff)
- `--qgray-100` / `bg-qgray-100` - Very light gray (#f0f1f2)
- `--qgray-200` / `bg-qgray-200` - Light gray borders (#e6e9eb)
- `--qgray-250` / `bg-qgray-250` - Light-medium gray (#dadee0)
- `--qgray-300` / `bg-qgray-300` - Medium-light gray (#ced3d6)
- `--qgray-400` / `bg-qgray-400` - Medium gray (#abb3b8)
- `--qgray-500` / `bg-qgray-500` - Mid gray (#676f73)
- `--qgray-550` / `bg-qgray-550` - Medium-dark gray (#505659)
- `--qgray-600` / `bg-qgray-600` - Dark gray text (#41494d)
- `--qgray-700` / `bg-qgray-700` - Darker gray (#363d40)
- `--qgray-800` / `bg-qgray-800` - Very dark gray (#293033)
- `--qgray-900` / `bg-qgray-900` - Near black (#1d2326)
- `--qgray-950` / `bg-qgray-950` - Darkest text (#090b0c)

**Neutral Scale:**
- `--qneutral-50` / `bg-qneutral-50` - Lightest neutral (#fff)
- `--qneutral-100` / `bg-qneutral-100` - Light neutral (#fafafa)
- `--qneutral-200` / `bg-qneutral-200` - Medium neutral (#f5f5f5)

**Special:**
- `--qfocus-500` / `focus:outline-qfocus-500` - Focus outline color (#0075a3)

---

**Note**: These guidelines should be followed for ALL Vertex platform implementations to ensure brand consistency and optimal user experience across the ecosystem. Always prefer Quartz colors over hardcoded values.
