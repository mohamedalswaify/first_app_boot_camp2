import 'package:flutter/material.dart';

import '../../data/models/register_request.dart';
import '../../data/services/auth_api_service.dart';
import '../widgets/app_text_field.dart';
import '../widgets/primary_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstName = TextEditingController();
  final _phone = TextEditingController();
  final _lastName = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();
  final _birthDateCtrl = TextEditingController(); // للعرض فقط

  final _api = AuthApiService();
  bool _acceptedPolicy = false;
  bool _loading = false;
  String? _gender; // 'male' or 'female'
  DateTime? _birthDate;
  String? _country;
  static const List<String> _countries = [
    'Saudi Arabia',
    'Egypt',
    'United Arab Emirates',
    'Kuwait',
    'Qatar',
    'Bahrain',
    'Oman',
    'Jordan',
    'Iraq',
    'Lebanon',
    'Syria',
    'Yemen',
    'Morocco',
    'Algeria',
    'Tunisia',
    'Libya',
    'Sudan',
    'Turkey',
    'United States',
    'United Kingdom',
    'India',
    'Pakistan',
  ];

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _email.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    _birthDateCtrl.dispose();
    super.dispose();
  }

  void _openPrivacyPolicy() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.7,
        minChildSize: 0.4,
        maxChildSize: 0.95,
        builder: (_, scroll) => Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            controller: scroll,
            children: const [
              Text('Privacy Policy',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 12),
              Text(
                'هنا نص سياسة الخصوصية… هذا نص تجريبي. يمكنك استبداله بالنص الفعلي أو فتح صفحة مخصصة.',
                textAlign: TextAlign.start,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickBirthDate() async {
    final now = DateTime.now();
    final initial = DateTime(now.year - 20, now.month, now.day);
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(1900),
      lastDate: now,
      initialDate: _birthDate ?? initial,
    );
    if (picked != null) {
      setState(() {
        _birthDate = picked;
        _birthDateCtrl.text =
            '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
      });
    }
  }

  String? _emailValidator(String? v) {
    if (v == null || v.trim().isEmpty) return 'الحقل مطلوب';
    final emailRegex = RegExp(r'^[\w\.\-]+@[\w\.\-]+\.\w+$');
    if (!emailRegex.hasMatch(v.trim())) return 'بريد إلكتروني غير صالح';
    return null;
  }

  String? _passwordValidator(String? v) {
    if (v == null || v.trim().isEmpty) return 'الحقل مطلوب';
    if (v.trim().length < 6) return 'الرقم السري يجب ألا يقل عن 6 أحرف';
    return null;
  }

  Future<void> _onRegister() async {
    // Validations الإضافية (الجنس، تاريخ الميلاد، تطابق كلمة السر)
    if (_gender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❌ من فضلك اختر النوع')),
      );
      return;
    }

    if (_country == null || _country!.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❌ من فضلك اختر الدولة')),
      );
      return;
    }

    if (_birthDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❌ من فضلك اختر تاريخ الميلاد')),
      );
      return;
    }
    if (_password.text.trim() != _confirmPassword.text.trim()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❌ تأكيد كلمة المرور لا يطابق')),
      );
      return;
    }

    if (!_acceptedPolicy) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❌ رجاءً وافق على سياسة الخصوصية')),
      );
      return;
    }

    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);
    try {
      final req = RegisterRequest(
        firstName: _firstName.text.trim(),
        lastName: _lastName.text.trim(),
        gender: _gender!, // male/female
        birthDate: _birthDate!,
        email: _email.text.trim(),
        password: _password.text.trim(),
        confirmPassword: _confirmPassword.text.trim(),
        country: _country!,
        phone: _phone.text.trim()!,
      );

      final res = await _api.register(req);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('✅ تم إنشاء الحساب: ${res.firstName} ${res.lastName}')),
      );

      // بعد التسجيل: ممكن نرجّع للشاشة السابقة (اللوجين) أو نروح للهوم
      Navigator.of(context).pop(); // رجوع للـ Login
      // أو:
      // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const HomeScreen()));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ $e')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Create Account'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Form(
            key: _formKey,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Sign Up',
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),

                    // First & Last
                    Row(
                      children: [
                        Expanded(
                          child: AppTextField(
                            controller: _firstName,
                            label: 'First Name',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: AppTextField(
                            controller: _lastName,
                            label: 'Last Name',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Gender (Radio)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Gender',
                          style: Theme.of(context).textTheme.bodyLarge),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile<String>(
                            value: 'male',
                            activeColor: Colors.blue,
                            groupValue: _gender,
                            title: const Text('Male'),
                            onChanged: (v) => setState(() => _gender = v),
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<String>(
                            value: 'female',
                            groupValue: _gender,
                            title: const Text('Female'),
                            onChanged: (v) => setState(() => _gender = v),
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Birth Date (TextField يعرض القيمة + DatePicker)
                    AppTextField(
                      controller: _birthDateCtrl,
                      label: 'Birth Date',
                      keyboardType: TextInputType.datetime,
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton.icon(
                        onPressed: _pickBirthDate,
                        icon: const Icon(Icons.calendar_today),
                        label: const Text('Choose Date'),
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: _country,
                      items: _countries
                          .map(
                              (c) => DropdownMenuItem(value: c, child: Text(c)))
                          .toList(),
                      onChanged: (v) => setState(() => _country = v),
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'الحقل مطلوب'
                          : null,
                      decoration: const InputDecoration(
                        labelText: 'Country',
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Email
                    AppTextField(
                      controller: _email,
                      label: 'Email',
                      keyboardType: TextInputType.emailAddress,
                    ),

                    const SizedBox(height: 12),

                    // Password & Confirm
                    AppTextField(
                      controller: _phone,
                      label: 'Phone',
                    ),
                    const SizedBox(height: 12),

                    // Password & Confirm
                    AppTextField(
                      controller: _password,
                      label: 'Password',
                      obscure: true,
                    ),
                    const SizedBox(height: 12),
                    AppTextField(
                      controller: _confirmPassword,
                      label: 'Confirm Password',
                      obscure: true,
                    ),
                    const SizedBox(height: 16),

                    CheckboxListTile(
                      value: _acceptedPolicy,
                      onChanged: (v) =>
                          setState(() => _acceptedPolicy = v ?? false),
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                      title: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          const Text('أوافق على '),
                          GestureDetector(
                            onTap: _openPrivacyPolicy,
                            child: const Text(
                              'سياسة الخصوصية',
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 8),

                    PrimaryButton(
                      text: 'Create Account',
                      loading: _loading,
                      onPressed: _onRegister,
                    ),

                    const SizedBox(height: 12),
                    // رابط رجوع للّوجين
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Already have an account? Login'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
