This document provides the Markdown table structure for populating the Minimum Viable Semantic Model (MVSM) data in an Excel spreadsheet. Each table below represents a dedicated tab in your Excel file, designed to facilitate structured data collection for the "Loan Funding Wire Function Health View" map and beyond.

### **Excel Sheet Structure (Tab by Tab)**

#### **Tab 1: Business\_Functions**

* **Purpose:** To define each unique business function.  
* **MVSM Entity:** Business Function

| Function Name | Owning Domain | Trigger Type | Internal User Role | Application UI | Business Process Mapped | Associated Journey | Business Capability | Criticality Tier |
| :---- | :---- | :---- | :---- | :---- | :---- | :---- | :---- | :---- |
|  |  |  |  |  |  |  |  |  |

#### **Tab 2: Business\_Services**

* **Purpose:** To define each unique business service.  
* **MVSM Entity:** Business Service

| Service Name | Owning Team | Associated Application | Has Business Signal | Has Distributed Tracing | Runbook Available | Business Process Mapped | Associated Capability |
| :---- | :---- | :---- | :---- | :---- | :---- | :---- | :---- |
|  |  |  |  |  |  |  |  |

#### **Tab 3: Technical\_Services**

* **Purpose:** To define each unique technical service.  
* **MVSM Entity:** Technical Service

| Service Name | Type | Upstream Dependency | Downstream Dependency | Team Owner | Alerting Coverage | Has Distributed Tracing | Runbook Available |
| :---- | :---- | :---- | :---- | :---- | :---- | :---- | :---- |
|  |  |  |  |  |  |  |  |

#### **Tab 4: Business\_Signals**

* **Purpose:** To list all business signals. This tab will have **multiple rows** for signals associated with the same Mapped Function or Service.  
* **MVSM Entity:** Business Signal

| Signal Name | Mapped Function or Service | Business Impact Description | Source of Truth | Signal Owner | SLO Defined | SLO Measured |
| :---- | :---- | :---- | :---- | :---- | :---- | :---- |
|  |  |  |  |  |  |  |

#### **Tab 5: Performance\_Signals**

* **Purpose:** To list all performance signals. This tab will also have **multiple rows** for signals associated with the same Mapped Service.  
* **MVSM Entity:** Performance Signal

| Signal Name | Mapped Service | Target Threshold | Source of Truth | Signal Owner | SLO Defined | SLO Measured |
| :---- | :---- | :---- | :---- | :---- | :---- | :---- |
|  |  |  |  |  |  |  |

#### **Tab 6: External\_Dependencies**

* **Purpose:** To define external systems your services rely on.  
* **MVSM Entity:** External Dependency

| Service Name | Interface Type | Contracted SLA | Alerting Coverage | Has Distributed Tracing | Runbook Available | Fallback/Retry Logic |
| :---- | :---- | :---- | :---- | :---- | :---- | :---- |
|  |  |  |  |  |  |  |
