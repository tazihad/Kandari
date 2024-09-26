## বিভিন্ন ভাষায় পড়ুন

- [English](README.md)
- [বাংলা](README.bn.md)

# কান্ডারী ওএস
কান্ডারী ওএস ফেডোরা অ্যাটমিকের উপর ভিত্তি করে তৈরি।

## ইনস্টলেশন  
দুইটি ইমেজ রয়েছে। `Kandari` এবং `Kandari NVIDIA`। আপনার হার্ডওয়্যার অনুযায়ী একটি বেছে নিন।

#### সহজ পদ্ধতি
আপনি যদি অন্য কোনো এটোমিক বিল্ড ব্যাবহার করে থাকেন তাহলে প্রথমে আনসাইন্ড বিল্ড রিবেস করে পরে সাইন্ড বিল্ড রিবেস করবেন। 

**আনসাইন্ড বিল্ড:** ⚠️    
- আনসাইন্ড বিল্ড রিবেস করুন প্রয়োজনীয় কিছু সাইনিং কি ইন্সটল করার জন্য।:
  ```
  rpm-ostree rebase ostree-unverified-registry:ghcr.io/tazihad/kandari:latest
  ```
- **Nvidia কান্ডারী** আনসাইন্ড বিল্ড:
  ```
  rpm-ostree rebase ostree-unverified-registry:ghcr.io/tazihad/kandari-nvidia:latest
  ```
- রিস্টার্ট করুন কম্পিউটার:
  ```
  systemctl reboot
  ```  
**সাইন্ড বিল্ড:** ✔️  
- সাইনড **Kandari** ইমেজে রিবেস করুন:  
  ```
  rpm-ostree rebase ostree-image-signed:docker://ghcr.io/tazihad/kandari:latest
  ```
- **Nvidia কান্ডারী** সাইন্ড বিল্ড:
  ```
  rpm-ostree rebase ostree-image-signed:docker://ghcr.io/tazihad/kandari-nvidia:latest
  ```
- রিস্টার্ট করুন কম্পিউটার
  ```
  systemctl reboot
  ```

  #### একটু কঠিন পদ্ধতি:
  **আনসাইনড** ইমেজে রিবেস না করে সরাসরি **সাইনড** ইমেজ ইনস্টল করুন।  
- পাবলিক কী ইনস্টল করুন:
  ```
  sudo mkdir -p /etc/pki/containers
  curl -O "https://raw.githubusercontent.com/tazihad/kandari/main/kandari.pub" -o kandari.pub
  sudo cp kandari.pub /etc/pki/containers/
  sudo restorecon -RFv /etc/pki/containers
  ```
- রেজিস্ট্রি কনফিগার করুন যাতে sigstore সাইন থাকে: 
  রেজিস্ট্রির জন্য একটি কনফিগারেশন ফাইল তৈরি করুন:
  ```
  sudo mkdir -p /etc/containers/registries.d
  sudo nano /etc/containers/registries.d/ghcr.io-tazihad-kandari.yaml
  ```
  নিচের বিষয়বস্তু যোগ করুন:
  ```
  docker:
    ghcr.io/tazihad/kandari:
      use-sigstore-attachments: true
  ```
  ফাইলটি সেভ করুন এবং তারপর টারমিনাল থেকে:
  ```
  sudo restorecon -RFv /etc/containers/registries.d/ghcr.io-tazihad-kandari.yaml
  ```
- পলিসি ঠিক করুন:
  নিচের ফাইল সেভ করুন:
  ```
  sudo cp /etc/containers/policy.json /etc/containers/policy.json.bak # Backup existing policy
  sudo nano /etc/containers/policy.json
  ```
  আপনার ফাইল পথ অনুযায়ী এই বিষয়বস্তুটি যোগ করুন:  
  ```
  {
      "default": [
          {
              "type": "reject"
          }
      ],
      "transports": {
          "docker": {
              "ghcr.io/tazihad/kandari": [
                  {
                      "type": "sigstoreSigned",
                      "keyPath": "/etc/pki/containers/kandari.pub",
                      "signedIdentity": {
                          "type": "matchRepository"
                      }
                  }
              ],
              "": [
                  {
                      "type": "insecureAcceptAnything"
                  }
              ]
          }
      }
  }
  ```
  ফাইলটি সেভ করুন এবং তারপর টারমিনাল থেকে:
  ```
  sudo restorecon -RFv /etc/containers/policy.json
  ```
  এখন কান্ডারী ওএস cosign ধারা ভেরিফাই হওয়ার জন্য প্রস্তুত।


## ভেরিফাই করুন  
গিটহাব থেকে `kandari.pub` ডাউনলোড করুন তারপর টারমিনাল থেকে ভেরিফাই করুন:
```
cosign verify --key https://raw.githubusercontent.com/tazihad/kandari/main/kandari.pub ghcr.io/tazihad/kandari-kde:latest
```
