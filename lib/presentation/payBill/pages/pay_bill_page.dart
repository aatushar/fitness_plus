import 'package:flutter/material.dart';

class PayBillPage extends StatefulWidget {
  final double dueAmount;

  const PayBillPage({Key? key, required this.dueAmount}) : super(key: key);

  @override
  State<PayBillPage> createState() => _PayBillPageState();
}

class _PayBillPageState extends State<PayBillPage> {
  // Color Constants
  static const Color _backgroundColor = Color(0xFF1A1A2E);
  static const Color _primaryColor = Color(0xFFE94560);
  static const Color _secondaryColor = Color(0xFF16213E);

  String _selectedPaymentMethod = '';
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _cardNameController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  final TextEditingController _upiIdController = TextEditingController();

  @override
  void dispose() {
    _cardNumberController.dispose();
    _cardNameController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _upiIdController.dispose();
    super.dispose();
  }

  void _processPayment() {
    if (_selectedPaymentMethod.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a payment method'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Show success dialog with modified layout to prevent overflow
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: _secondaryColor,
        contentPadding: const EdgeInsets.all(20),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 80,
                shadows: [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.5),
                    blurRadius: 20,
                    spreadRadius: 5,
                  )
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Payment Successful',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15),
              Text(
                'Your payment of ৳${widget.dueAmount.toStringAsFixed(2)} has been processed successfully.',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  Navigator.pop(context, true); // Return to previous page with success
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Done',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        backgroundColor: _secondaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Pay Bill',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Due Amount Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFE94560), Color(0xFFFF6B9D)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFE94560).withOpacity(0.4),
                      blurRadius: 15,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      'Total Due Amount',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '৳${widget.dueAmount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Membership Fee',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Payment Methods Title
              const Text(
                'Select Payment Method',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),

              // Payment Method Options
              _buildPaymentMethodCard(
                'Credit/Debit Card',
                Icons.credit_card,
                'card',
              ),
              const SizedBox(height: 15),
              _buildPaymentMethodCard(
                'UPI Payment',
                Icons.account_balance_wallet,
                'upi',
              ),
              const SizedBox(height: 15),
              _buildPaymentMethodCard(
                'Net Banking',
                Icons.account_balance,
                'netbanking',
              ),
              const SizedBox(height: 15),
              _buildPaymentMethodCard(
                'Cash Payment',
                Icons.money,
                'cash',
              ),
              const SizedBox(height: 30),

              // Payment Details Form
              if (_selectedPaymentMethod == 'card') _buildCardForm(),
              if (_selectedPaymentMethod == 'upi') _buildUPIForm(),
              if (_selectedPaymentMethod == 'netbanking') _buildNetBankingForm(),
              if (_selectedPaymentMethod == 'cash') _buildCashPaymentInfo(),

              const SizedBox(height: 30),

              // Pay Now Button
              if (_selectedPaymentMethod.isNotEmpty)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _processPayment,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4CAF50),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 5,
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.payment, size: 24),
                        SizedBox(width: 10),
                        Text(
                          'Pay Now',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentMethodCard(String title, IconData icon, String method) {
    final isSelected = _selectedPaymentMethod == method;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPaymentMethod = method;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: _secondaryColor,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected ? _primaryColor : Colors.transparent,
            width: 2,
          ),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: _primaryColor.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ]
              : [],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected
                    ? _primaryColor.withOpacity(0.2)
                    : Colors.grey.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: isSelected ? _primaryColor : Colors.grey,
                size: 30,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey[400],
                  fontSize: 18,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: _primaryColor,
                size: 28,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardForm() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _secondaryColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Card Details',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          _buildTextField(_cardNumberController, 'Card Number', '1234 5678 9012 3456'),
          const SizedBox(height: 15),
          _buildTextField(_cardNameController, 'Cardholder Name', 'John Doe'),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: _buildTextField(_expiryController, 'Expiry', 'MM/YY'),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: _buildTextField(_cvvController, 'CVV', '123'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUPIForm() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _secondaryColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'UPI Details',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          _buildTextField(_upiIdController, 'UPI ID', 'yourname@upi'),
          const SizedBox(height: 15),
          const Text(
            'Popular UPI Apps',
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildUPIAppButton('GPay', Colors.blue),
              _buildUPIAppButton('PhonePe', Colors.purple),
              _buildUPIAppButton('Paytm', Colors.indigo),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNetBankingForm() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _secondaryColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select Your Bank',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          _buildBankOption('State Bank of India'),
          _buildBankOption('HDFC Bank'),
          _buildBankOption('ICICI Bank'),
          _buildBankOption('Axis Bank'),
          _buildBankOption('Other Banks'),
        ],
      ),
    );
  }

  Widget _buildCashPaymentInfo() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _secondaryColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          const Icon(Icons.info_outline, color: Color(0xFFFFEB3B), size: 50),
          const SizedBox(height: 15),
          const Text(
            'Cash Payment',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Please visit our gym reception to make cash payment. Show this reference number:',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[400], fontSize: 14),
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text(
              'REF: #FIT2025001',
              style: TextStyle(
                color: Color(0xFFE94560),
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, String hint) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: const TextStyle(color: Colors.grey),
        hintStyle: TextStyle(color: Colors.grey[600]),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[700]!),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: _primaryColor),
          borderRadius: BorderRadius.circular(10),
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
      ),
    );
  }

  Widget _buildUPIAppButton(String name, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color),
      ),
      child: Text(
        name,
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildBankOption(String bankName) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[700]!),
      ),
      child: Row(
        children: [
          const Icon(Icons.account_balance, color: Colors.grey, size: 24),
          const SizedBox(width: 15),
          Text(
            bankName,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
    );
  }
}