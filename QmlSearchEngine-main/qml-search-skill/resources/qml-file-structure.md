
# QML File Structure
This document outlines the typical structure of QML files to help users understand and navigate QML codebases effectively.

## Visual Folder Structure (including root)

```
QmlSearchEngine-main/
└── qml-search-skill/
	└── QML/
		├── drive/
		│   └── etc/
		│       └── rc/
		│           └── qml/
		│               ├── cases/
		│               ├── components/
		│               ├── header/
		│               ├── login/
		│               ├── main.qml
		│               ├── patients/
		│               ├── settings/
		│               └── workflow/
		├── plugin/
		│   ├── cranial/
		│   │   ├── surgeonsettings/
		│   │   │   └── etc/
		│   │   │       └── rc/
		│   │   │           └── qml/
		│   │   │               ├── CoordinateSettings.qml
		│   │   │               ├── CranialSettingsPlugin.qml
		│   │   │               └── ViewportSettings.qml
		│   │   └── workflow/
		│   │       └── etc/
		│   │           └── rc/
		│   │               └── qml/
		│   │                   ├── components/
		│   │                   ├── cranial.qml
		│   │                   ├── debug.qml
		│   │                   └── overlays/
		│   ├── spine/
		│   │   ├── surgeonsettings/
		│   │   │   └── etc/
		│   │   │       └── rc/
		│   │   │           └── qml/
		│   │   │               ├── CheckableSettingsItem.qml
		│   │   │               ├── PairingSystemsSettings.qml
		│   │   │               ├── SliderSettingsItem.qml
		│   │   │               ├── SurgeonSettingsDescription.qml
		│   │   │               ├── SurgeonSettingsPlugin.qml
		│   │   │               ├── ViewportLayoutSettings.qml
		│   │   │               ├── ViewportSettings.qml
		│   │   │               └── WorkflowSettings.qml
		│   │   └── workflow/
		│   │       └── etc/
		│   │           └── rc/
		│   │               └── qml/
		│   │                   ├── applicationheader/
		│   │                   ├── casesetup/
		│   │                   ├── components/
		│   │                   ├── debug.qml
		│   │                   ├── image/
		│   │                   ├── instrumentpairing/
		│   │                   ├── instrumentverification/
		│   │                   ├── minimaldebug.qml
		│   │                   ├── navigatesidebar/
		│   │                   ├── overlays/
		│   │                   ├── plansidebar/
		│   │                   ├── registration/
		│   │                   ├── spine.qml
		│   │                   ├── trackbar/
		│   │                   └── viewports/
```