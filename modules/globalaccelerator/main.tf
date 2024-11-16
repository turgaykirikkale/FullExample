resource "aws_globalaccelerator_accelerator" "example" {
  name            = "Example"
  ip_address_type = "IPV4"
  ip_addresses    = ["1.2.3.4"]
  enabled         = true

  attributes {
    flow_logs_enabled   = true
    flow_logs_s3_bucket = "example-bucket"
    flow_logs_s3_prefix = "flow-logs/"
  }
}

resource "aws_globalaccelerator_listener" "example" {
  accelerator_arn = aws_globalaccelerator_accelerator.example.id
  client_affinity = "SOURCE_IP"
  protocol        = "TCP"

  port_range {
    from_port = 80
    to_port   = 80
  }
}

resource "aws_globalaccelerator_endpoint_group" "example" {
  listener_arn = aws_globalaccelerator_listener.example.id

  endpoint_configuration {
    endpoint_id = var.lb_arn
    weight      = 100
  }

  health_check_interval_seconds = 30
  health_check_path             = "/health"
  health_check_port             = 80
  health_check_protocol         = "HTTP"
}


/*

AWS Global Accelerator is a network service used to optimize application traffic and provide faster and more reliable access worldwide. It routes user traffic through AWS's global network, reducing latency and ensuring that applications perform with high efficiency. Here are the key features of AWS Global Accelerator:

1. **Faster Access:** Global Accelerator directs user traffic to the nearest AWS edge locations based on geographical proximity. This results in faster access to applications.

2. **High Availability and Routing:** Traffic is routed over AWS's global network to ensure optimal performance. In case of traffic congestion or network failures, automatic rerouting ensures high availability for your application.

3. **Automatic Load Balancing:** Traffic is routed to the closest and healthiest AWS resources (e.g., EC2, ALB, NLB). This helps in balancing the application load effectively.

4. **Advanced DDoS Protection:** AWS Global Accelerator integrates with AWS Shield Advanced, providing additional protection against DDoS (Distributed Denial of Service) attacks.

5. **Simple Setup:** Global Accelerator is easy to configure to manage and route traffic for an application. Users can set up traffic routing with just two global IP addresses.

AWS Global Accelerator is an ideal solution for applications with global access requirements, meeting the needs for low latency, high availability, and security.


**Unicast IP** ve **Anycast IP** terimleri, AWS Global Accelerator gibi ağ hizmetlerinde kullanılan yönlendirme yöntemlerini ifade eder. Her ikisi de farklı şekillerde trafiği yönlendirmek için kullanılır. İşte bu iki IP türünün ne anlama geldiği ve AWS Global Accelerator ile nasıl kullanıldıklarına dair açıklamalar:

### 1. **Unicast IP:**
   - **Tanım:** Unicast, bir ağda verilerin tek bir kaynaktan tek bir hedefe gönderilmesidir. Yani, tek bir cihazdan başka bir tek cihaza veri iletilir.
   - **Kullanım:** Unicast IP, belirli bir kaynağa (IP adresine) trafiği yönlendiren bir IP adresi türüdür. Trafik yalnızca tek bir hedef IP adresine gider.
   - **AWS Global Accelerator'daki Rolü:** Global Accelerator, her uygulama son noktası için bir **Unicast IP** adresi kullanır. Bu, her uygulama son noktasının (örneğin, bir EC2 instance'ı) belirli bir IP adresine sahip olduğu anlamına gelir. Bu IP adresi, sadece o son noktaya yönlendirilir ve sadece o son nokta ile iletişim kurulur.

### 2. **Anycast IP:**
   - **Tanım:** Anycast, bir ağda aynı IP adresinin birden fazla farklı cihazda bulunmasıdır. Trafik, bu IP adresine yönlendirildiğinde, en yakın veya en iyi yanıt veren cihaz tarafından işlenir. Yani, birden fazla hedefin aynı IP'yi paylaşmasına olanak tanır.
   - **Kullanım:** Anycast IP, tek bir IP adresini birden fazla cihaz (sunucu, veri merkezi vb.) arasında paylaşmayı sağlar. Trafik, genellikle en yakın veya en az yoğun olan hedefe yönlendirilir.
   - **AWS Global Accelerator'daki Rolü:** Global Accelerator, her iki **Unicast** ve **Anycast** IP kullanabilir, ancak genellikle **Anycast IP** kullanır. Anycast, AWS'nin küresel ağının edge lokasyonlarında bulunan en yakın noktaya yönlendirilmiş trafiği sağlar. Bu, düşük gecikme süresi ve yüksek hız için trafiğin daha yakın bir kaynağa yönlendirilmesini sağlar.

### Özetle:
- **Unicast IP:** Trafik belirli bir kaynak IP adresine yönlendirilir. Her bir son nokta (EC2 instance, Load Balancer vb.) kendi benzersiz IP adresine sahip olur.
- **Anycast IP:** Aynı IP adresi birden fazla sunucuya ait olabilir. Trafik, en yakın veya en uygun sunucuya yönlendirilir.

**AWS Global Accelerator**'da, **Anycast IP** kullanımı, global trafiğin dünya çapında en yakın AWS lokasyonlarına yönlendirilmesine olanak tanır. Bu sayede, daha hızlı, daha verimli ve düşük gecikmeli bağlantılar sağlanır.


**AWS Global Accelerator** ve **Amazon CloudFront**, her ikisi de AWS tarafından sunulan ağ hizmetleridir, ancak farklı kullanım senaryolarına hizmet ederler ve farklı teknolojilere dayanırlar. İşte bu iki hizmet arasındaki temel farklar:

### 1. **AWS Global Accelerator**
AWS Global Accelerator, küresel ağ trafiğini optimize etmek için tasarlanmış bir ağ hizmetidir. Ana amacı, kullanıcı trafiğini AWS'nin küresel ağındaki en yakın lokasyonlara yönlendirerek uygulamalara hızlı ve güvenilir erişim sağlamaktır. Genellikle, **yük dengeleme** ve **trafik yönlendirme** için kullanılır.

**Temel Özellikler:**
- **Küresel Trafik Optimizasyonu:** Trafiği AWS'nin küresel ağında en yakın noktaya yönlendirir, böylece düşük gecikme ve yüksek performans sağlar.
- **Unicast ve Anycast IP kullanımı:** Uygulamanız için global IP adresleri sağlar. Anycast, en iyi performansı sağlamak için trafiği doğru lokasyona yönlendirir.
- **Yük Dengeleme:** Global Accelerator, trafiği birden fazla AWS kaynağına (örneğin, EC2 instance'ları, Load Balancers) yönlendirir ve bunları yük dengeleme amacıyla kullanır.
- **DDoS Koruması:** AWS Shield Advanced ile entegrasyon sayesinde, DDoS saldırılarına karşı ek koruma sağlar.
- **Uygulama ve Ağ Katmanı Desteği:** Global Accelerator, hem **Layer 4** (TCP/UDP) hem de **Layer 7** (HTTP/HTTPS) trafiği destekler.
- **Faydalar:** Dünya çapında düşük gecikme süreleri, yüksek erişilebilirlik ve yönlendirme optimizasyonu sağlar.

**Kullanım Senaryoları:**
- Global uygulamalar için trafiği optimize etmek (örn. oyunlar, finansal hizmetler, IoT uygulamaları).
- Global yük dengeleme ve yüksek erişilebilirlik gereksinimleri.
- Yüksek performans gerektiren, düşük gecikmeli uygulamalar.

---

### 2. **Amazon CloudFront**
Amazon CloudFront, AWS'nin içerik dağıtım ağı (CDN) hizmetidir. Ana amacı, web içeriğini (statik ve dinamik içerik) son kullanıcılarına hızlı ve güvenilir bir şekilde dağıtmaktır. CloudFront, içeriklerinizi dünya çapındaki edge lokasyonları üzerinden sunarak gecikmeyi azaltır.

**Temel Özellikler:**
- **İçerik Dağıtımı:** Web içeriği (örneğin, HTML, CSS, JavaScript, görseller, videolar) ve uygulama içeriği (API yanıtları) hızlı bir şekilde kullanıcıya sunulmak üzere cache'lenir.
- **Edge Lokasyonları:** CloudFront, 300'ün üzerinde edge lokasyonuyla dünya çapında içerik dağıtımı yapar.
- **Düşük Gecikme ve Yüksek Performans:** Trafik, en yakın edge lokasyonuna yönlendirilerek düşük gecikmeli erişim sağlar.
- **Dinamik İçerik Desteği:** CloudFront, yalnızca statik içerik değil, dinamik içerik (örneğin API yanıtları) de sunabilir.
- **SSL/TLS Desteği ve Güvenlik:** CloudFront, SSL/TLS şifrelemesi ve diğer güvenlik özelliklerini sunarak güvenli içerik dağıtımı sağlar.
- **DDoS Koruması:** AWS Shield Standard ile entegre çalışır, böylece temel DDoS koruması sağlar.
- **Otomatik Yönlendirme:** Trafiği en yakın ve en uygun lokasyona yönlendirerek hızlı yükleme süreleri sağlar.

**Kullanım Senaryoları:**
- Web siteleri ve uygulamalar için içerik dağıtımı (statik ve dinamik).
- Video akış servisleri, medya içerikleri veya yazılım dağıtımı gibi içerik yoğun uygulamalar.
- Düşük gecikmeli, yüksek performanslı içerik erişimi ve izleme gereksinimleri.

---

### **Global Accelerator vs. CloudFront: Temel Farklar**

| Özellik                         | **AWS Global Accelerator**                                      | **Amazon CloudFront**                                            |
|----------------------------------|------------------------------------------------------------------|------------------------------------------------------------------|
| **Ana Amaç**                     | Küresel ağ trafiği optimizasyonu ve yük dengeleme.              | İçerik dağıtımı (CDN) ve web uygulamaları için hızlandırma.      |
| **Trafik Türü**                  | TCP/UDP ve HTTP/HTTPS (Layer 4 ve Layer 7).                      | HTTP/HTTPS (Layer 7) içeriği.                                    |
| **Kullanım Senaryosu**           | Global uygulama optimizasyonu, yük dengeleme, düşük gecikme.    | Statik ve dinamik web içeriği dağıtımı, video akışları.          |
| **Küresel Trafik Yönetimi**      | Trafiği AWS küresel ağında optimize eder.                        | Trafiği CloudFront edge lokasyonlarında optimize eder.           |
| **Edge Lokasyonları**            | AWS’nin küresel ağındaki edge lokasyonları kullanılır.          | 300+ dünya çapında edge lokasyonu ile içerik dağıtımı yapar.     |
| **DDoS Koruması**                | AWS Shield Advanced ile güçlü DDoS koruması sağlar.              | AWS Shield Standard ile temel DDoS koruması sağlar.              |
| **Uygulama Katmanı Desteği**     | Hem Layer 4 hem de Layer 7 desteği.                              | Sadece Layer 7 (HTTP/HTTPS) desteği.                             |
| **Kullanıcı Son Noktaları**      | Genellikle uygulama son noktaları (EC2, NLB, ALB) kullanılır.  | Genellikle statik içerik sunucuları ve medya dağıtım için kullanılır. |

### Sonuç:
- **AWS Global Accelerator** genellikle küresel trafiği optimize etmek, yüksek erişilebilirlik ve yük dengelemesi sağlamak için kullanılır. Eğer küresel uygulama trafiğini yönetiyorsanız, düşük gecikme ve yüksek erişilebilirlik gereksinimleriniz varsa, Global Accelerator ideal bir çözümdür.
- **Amazon CloudFront** ise içerik dağıtımı (CDN) için mükemmeldir. Web içeriği, medya dosyaları ve API yanıtlarını hızlı bir şekilde son kullanıcıya ulaştırmak için CloudFront'u tercih edebilirsiniz.

Her iki hizmetin de kullanım alanları farklıdır, ancak bazı durumlarda birlikte de kullanılabilirler. Örneğin, içerik dağıtımı için CloudFront kullanılırken, global trafiği optimize etmek için Global Accelerator da devreye girebilir.

*/
