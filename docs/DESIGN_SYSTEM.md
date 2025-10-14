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

### **Color Palette**

#### *Primary Colors:*

- **Primary Green:** `#3DCD58` - Used for primary actions, success states, and brand accents
- **Deep Green:** `#003310` - Used for backgrounds and high-contrast text  
- **Forest Green:** `#005C1E` - Used for secondary elements and hover states

#### *Supporting Colors:*

- **Ocean Blue:** `#0075A3` - Used for information and secondary actions
- **Accent Purple:** `#AB6DE4` - Used sparingly for highlights and special indicators
- **Warning Yellow:** `#FFD766` - Used for warnings and caution states

#### *Neutral Colors:*

- **Background:** `#ffffff` (light mode), `#003310` (dark mode)
- **Card Background:** `#ffffff` with subtle shadows
- **Text Primary:** `#030213` (near black)
- **Text Secondary:** `#717182` (muted gray)
- **Borders:** `rgba(0, 0, 0, 0.1)` (subtle gray)

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

- **Primary:** Filled with `#3DCD58`, white text, used for main actions
- **Secondary:** Outlined with primary color, transparent background
- **Tertiary:** Text-only with primary color, minimal emphasis
- **Sizes:** Small (`size="sm"`), Default, Large for different contexts
- Always include proper loading and disabled states

#### *Cards:*

- Use `bg-card` with `border` and `rounded-lg`
- Apply subtle shadows: `shadow-sm` for most cards
- Maintain `p-6` internal padding for content
- Use `space-y-4` for internal element spacing

#### *Tables & Lists:*

- Zebra striping using `even:bg-muted/50`
- Hover states using green with partial opacity
- Consistent column padding with `px-4 py-2`
- Header styling with `font-medium text-muted-foreground`

#### *Forms & Inputs:*

- Use `input-background` (#f3f3f5) for input fields
- Label styling: `font-medium` with proper spacing
- Group related inputs with consistent spacing
- Provide clear validation feedback

#### *Status Indicators:*

- **Published/Success:** Use primary green (`#3DCD58`)
- **Draft/Pending:** Use muted colors (`text-muted-foreground`)
- **Warning:** Use warning yellow (`#FFD766`)
- **Error:** Use destructive red (`text-destructive`)

#### *Navigation & Hierarchy:*

- Tree indentation: 24px increments per level
- Expand/collapse icons: Use lucide-react icons consistently
- Breadcrumbs: Use muted text with proper separators
- Active states: Use primary green background/border

### **Interactive States & Hover System**

#### *Green Hover System for Brand Consistency:*

- **Interactive Buttons:** Use `hover-green-dark` class (forest green with 20% opacity)
- **Standard Rows:** Use `hover-green` class for primary interactions (10% opacity)
- **Subtle Rows:** Use `hover-green-subtle` class for table rows (5% opacity)
- **Transitions:** Always include `transition-colors duration-200` for smooth interactions

### **Implementation Guidelines**

#### *Development Best Practices:*

- Use vertex-ui-shared components as the primary UI library following established patterns
- Implement responsive layouts using CSS Grid and Flexbox as defined in component standards
- Maintain code modularity with shared components and utilities in separate files
- Follow established spacing patterns using the 8px grid system for consistency

#### *Brand Consistency:*

- Apply Quartz SB color palette consistently across all user interfaces
- Use designated hover states and interaction patterns for unified user experience
- Implement proper typography hierarchy with specified font families and weights
- Maintain visual consistency with established component design standards

---

## 🚨 **Critical Implementation Rules**

### **MANDATORY Requirements for Vertex UI Implementation:**

1. **🎨 Use Quartz SB Design System**: All UI components MUST follow the color palette, typography, and spacing guidelines above
2. **🔧 vertex-ui-shared First**: Always use `@se-sustainability-business/vertex-ui-shared` components when available
3. **🎭 Consistent Hover States**: Implement the green hover system for all interactive elements
4. **📐 8px Grid System**: All spacing and layout MUST use multiples of 8px
5. **🔤 Typography Hierarchy**: Follow the specified font hierarchy and weights
6. **🌈 Brand Colors**: Use the specified color palette consistently across all interfaces

### **Color Usage Examples:**

```css
/* Primary Actions */
.btn-primary {
  background-color: #3DCD58; /* Primary Green */
  color: white;
}

/* Hover States */
.hover-green {
  background-color: rgba(61, 205, 88, 0.1); /* 10% opacity */
}

.hover-green-dark {
  background-color: rgba(0, 92, 30, 0.2); /* Forest Green 20% opacity */
}

/* Status Indicators */
.status-success { color: #3DCD58; } /* Primary Green */
.status-warning { color: #FFD766; } /* Warning Yellow */
.status-info { color: #0075A3; } /* Ocean Blue */
```

### **Typography Usage Examples:**

```css
/* Font Families */
.font-primary { font-family: 'Nunito Sans', sans-serif; }
.font-display { font-family: 'Nunito', sans-serif; }

/* Typography Scale */
.text-h1 { font-size: 28px; font-weight: 500; } /* 2xl, medium */
.text-h2 { font-size: 20px; font-weight: 500; } /* xl, medium */
.text-body { font-size: 14px; font-weight: 400; } /* base, normal */
```

---

## 📚 **Integration with vertex-ui-shared**

When implementing components, always check vertex-ui-shared first:

```typescript
// ✅ CORRECT - Use vertex-ui-shared components
import { VertexButton } from '@se-sustainability-business/vertex-ui-shared/button';
import { VertexCard } from '@se-sustainability-business/vertex-ui-shared/card';
import { VertexTable } from '@se-sustainability-business/vertex-ui-shared/table';

// Apply Quartz SB styling
<VertexButton 
  variant="primary" 
  className="bg-[#3DCD58] hover:bg-[#005C1E] transition-colors duration-200"
>
  {{ 'action.save' | translate }}
</VertexButton>
```

---

## 🔗 **References**

- **Storybook Reference**: <https://vertex-components-non.sb.se.com>
- **vertex-ui-shared Documentation**: Check component library for latest patterns
- **TailwindCSS**: Used for utility classes following 8px grid system
- **Lucide React**: Icon library for consistent iconography

---

**Note**: These guidelines should be followed for ALL Vertex platform implementations to ensure brand consistency and optimal user experience across the ecosystem.
