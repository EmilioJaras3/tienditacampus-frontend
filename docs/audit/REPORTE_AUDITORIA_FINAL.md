# 🛡️ Reporte de Auditoría Técnica: TienditaCampus (Versión Final)

Este reporte consolida los hallazgos de la auditoría "No Supongas" (NTTU) realizada sobre el ecosistema de **TienditaCampus**, evaluando la infraestructura distribuida, la calidad del código, la seguridad y el cumplimiento de las rúbricas académicas.

---

## 📊 1. Evaluación General por Rúbricas

### A. Rúbrica: Proyecto Integrador
| Criterio | Puntaje Sugerido | Estado | Observaciones |
| :--- | :--- | :--- | :--- |
| **Estabilidad Técnica** | **3.5 / 5** | ⚠️ Regular | La infraestructura es robusta, pero existen errores de esquema en `unit_cost` y truncamiento de strings (500 chars). |
| **Cumplimiento Funcional** | **4 / 5** | ✅ Bueno | Flujos de Auth y Dashboard operativos. Marketplace presenta glitches de carga por desajuste de DB. |
| **UX / UI (Neo-brutalismo)** | **5 / 5** | 🌟 Sobresaliente | Estética excepcional, coherente y moderna. Marco legal integrado en el footer. |
| **Investigación (Hipótesis)** | **5 / 5** | 🌟 Sobresaliente | Repositorio cuenta con reporte LaTeX detallado y análisis SQL de ROI y tendencias. |

### B. Rúbrica: Estándares y Métricas
| Criterio | Estado | Evidencia |
| :--- | :--- | :--- |
| **Autenticación (2FA)** | ❌ Insuficiente | No se detectó implementación de doble factor de forma activa en el código de producción. |
| **Automatización (Postman)** | ✅ Sobresaliente | Colección de 40+ endpoints con ambientes de producción (`TienditaCampus_Full_Collection`). |
| **Pruebas (Selenium)** | ⚠️ Desarrollado | Planeación de QA visible en bitácora, ejecución manual verificada por navegador. |

### C. Rúbrica: Base de Datos Avanzada
| Criterio | Implementación |
| :--- | :--- |
| **Normalización (3FN)** | Verificada en esquemas de `users`, `products` y `sales` con integridad referencial. |
| **Objetos Lógicos** | Uso de **Materialized Views** (`weekly_performance_mv`) y **Vistas** de ROI. |
| **Simulación (Seeding)** | **Data Factory** con 60 días de historial generado dinámicamente (`seed_generator.js`). |
| **Seguridad de BD** | Implementación de **RBAC** en PostgreSQL (Roles `product_manager`, `viewer`). |

### D. Rúbrica: Arquitectura SOA & Web Services
| Criterio | Estado |
| :--- | :--- |
| **Desacoplamiento** | **Total**. Frontend en Vercel, Backend y BD en AWS EC2 separadas. |
| **Protocolos** | RESTful API con uso correcto de verbos HTTP, DTOs y validación vía `class-validator`. |
| **Seguridad Web** | Implementación de **JWT**, Hashing (Bcrypt) y **Proxy de Vercel** para Mixed Content. |

---

## 🔍 2. Auditoría en Vivo (NTTU) - Evidencias

### Conectividad de Infraestructura
Se verificó la comunicación interna entre las instancias de AWS mediante la red privada de la VPC.
> **Comando**: `nc -zv 172.31.74.4 5432`  
> **Resultado**: `Connection succeeded!`

### Análisis de Logs (Glitches Críticos)
Durante la auditoría NTTU del Marketplace, se identificaron excepciones en el Backend:
1.  **Schema Drift**: `column InventoryRecord.unit_cost does not exist`. Se requiere sincronización de TypeORM con la base de datos de producción.
2.  **Validación de Datos**: Algunos campos de descripción exceden los 500 caracteres, bloqueando la creación de productos en producción.

---

## ⚖️ 3. Cumplimiento Legal y Ético
Se verificó en [https://frontend-one-zeta-45.vercel.app/](https://frontend-one-zeta-45.vercel.app/) la existencia del **Marco Legal & Convivencia**.
*   **Alcance**: Responsabilidad limitada, prohibición de sustancias y normas de comunidad.
*   **UI**: Enlace visible en el footer bajo estética Neo-brutalista.

---

## 🚀 4. Roadmap para Puntaje 100% (Acción Requerida)
Para alcanzar la excelencia absoluta en la entrega final:
1.  **Sincronizar Migraciones**: Ejecutar `npm run typeorm migration:run` en el backend para resolver el campo `unit_cost`.
2.  **Implementar 2FA**: Añadir un campo `isTwoFactorEnabled` y un flujo simple de TOTP.
3.  **Ajustar Triggers**: Migrar el cálculo de ROI de Vistas a Triggers de PostgreSQL para mejorar la eficiencia (Criterio de Base de Datos).

---
**Reporte Generado por Antigravity (Advanced Agentic Coding)**  
*Fecha: 11 de Abril, 2026*  
*Status: Auditoría Completa*
