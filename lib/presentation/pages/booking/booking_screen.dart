import 'package:fluffypawmobile/data/models/pet_model.dart';
import 'package:fluffypawmobile/dependency_injection/dependency_injection.dart';
import 'package:fluffypawmobile/presentation/pages/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluffypawmobile/data/models/service_model.dart';

class BookingPage extends ConsumerStatefulWidget {
  final int serviceId;
  BookingPage({required this.serviceId});

  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends ConsumerState<BookingPage> {
  Set<int> selectedServiceIds = {};
  Set<int> selectedPetIds = {};
  String? paymentMethod;
  String description = '';

  @override
  void initState() {
    super.initState();
    // Gọi ViewModel để tải dịch vụ khi khởi tạo trang
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(bookingViewModelProvider(widget.serviceId).notifier).getAllStoreServiceByServiceId(widget.serviceId);

    });
  }

  @override
  Widget build(BuildContext context) {
    final bookingState = ref.watch(bookingViewModelProvider(widget.serviceId));
    final petState = ref.watch(petViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Book a date'),
      ),
      body: bookingState.isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSalonCard(),
              SizedBox(height: 20),
              _buildPetList(petState.pets),
              SizedBox(height: 20),
              // Text('Availability', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              // SizedBox(height: 10),
              //_buildTimeSlots(),
              //SizedBox(height: 20),
              Text('Services', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              bookingState.errorMessage != null
                  ? Center(child: Text(bookingState.errorMessage!))
                  : _buildServicesList(bookingState.serviceList),
              SizedBox(height: 10),
              Text(
                'Prices are estimative and the payment will be made at the location.',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              SizedBox(height: 20),
              _buildPaymentMethodOptions(),
              SizedBox(height: 20),
              _buildAddNoteSection(),
              SizedBox(height: 20),

              _buildConfirmButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSalonCard() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Shinny Fur Saloon',
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.location_on, color: Colors.white, size: 16),
              SizedBox(width: 4),
              Text('70 North Street, London, UK', style: TextStyle(color: Colors.white)),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Text('4.6', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              SizedBox(width: 4),
              Row(
                children: List.generate(5, (index) =>
                    Icon(index < 4 ? Icons.star : Icons.star_border, color: Colors.white, size: 16)
                ),
              ),
              Spacer(),
              Text('230 reviews', style: TextStyle(color: Colors.white)),
            ],
          ),
        ],
      ),
    );
  }
  Widget _buildPetList(List<PetModel> pets) {
    if (pets.isEmpty) {
      return Center(child: Text('No pets available'));
    }

    return Column(
      children: pets.map((pet) => _buildPetItem(pet)).toList(),
    );
  }
  Widget _buildPetItem(PetModel pet) {
    final isSelected = selectedPetIds.contains(pet.id);

    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            selectedPetIds.remove(pet.id);
          } else {
            selectedPetIds.add(pet.id);
          }
        });
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 8),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue[100] : Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: isSelected ? Colors.blue : Colors.grey),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              pet.name, // Assuming `PetModel` has a `name` field
              style: TextStyle(color: isSelected ? Colors.blue : Colors.black),
            ),
            Image.network(
              pet.image ?? '', // Hiển thị hình ảnh từ URL của pet
              width: 50,
              height: 50,
              fit: BoxFit.cover, // Đảm bảo hình ảnh được cắt đúng khung
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildDatePicker() {
    return Container(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 7,
        itemBuilder: (context, index) {
          return Container(
            width: 60,
            margin: EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              border: Border.all(color: index == 2 ? Colors.blue : Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][index]),
                SizedBox(height: 4),
                Text('${index + 11}', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTimeSlots() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: ['09:00', '10:00', '11:00', '12:00', '13:00', '14:00', '15:00', '16:00']
          .map((time) => Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: time == '11:00' ? Colors.orange : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(time),
      ))
          .toList(),
    );
  }

  Widget _buildServicesList(List<ServiceModel> services) {
    if (services.isEmpty) {
      return Center(child: Text('No services available'));
    }

    return Column(
      children: services.map((service) => _buildServiceItem(service)).toList(),
    );
  }

  Widget _buildServiceItem(ServiceModel service) {
    final isSelected = selectedServiceIds.contains(service.id);

    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            selectedServiceIds.remove(service.id);
          } else {
            selectedServiceIds.add(service.id);
          }
        });
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 8),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue[100] : Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: isSelected ? Colors.blue : Colors.grey),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              service.startTime.toString(), // Assuming `ServiceModel` has a `name` field
              style: TextStyle(color: isSelected ? Colors.blue : Colors.black),
            ),
            Text(
              service.currentPetOwner.toString() +'/' +service.limitPetOwner.toString(),
              style: TextStyle(color: isSelected ? Colors.blue : Colors.black),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildPaymentMethodOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Select Payment Method", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        RadioListTile(
          title: Text("PayOS"),
          value: "PayOS",
          groupValue: paymentMethod,
          onChanged: (value) {
            setState(() {
              paymentMethod = value as String?;
            });
          },
        ),
        RadioListTile(
          title: Text("COD"),
          value: "COD",
          groupValue: paymentMethod,
          onChanged: (value) {
            setState(() {
              paymentMethod = value as String?;
            });
          },
        ),
      ],
    );
  }

  Widget _buildAddNoteSection() {
    return TextField(
      decoration: InputDecoration(
        labelText: 'Add Note',
        border: OutlineInputBorder(),
      ),
      maxLines: 3,
      onChanged: (value) {
        setState(() {
          description = value;
        });
      },
    );
  }

  Widget _buildConfirmButton() {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        child: Text('Confirm Booking'),
        onPressed: () async {
          if (selectedPetIds.isEmpty) {
            // Handle case where no pets are selected
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Please select at least one pet')),
            );
            return;
          }

          // Convert Set to List<int> and pass it to the createBookingForUser method
          final bookingSuccess = await ref.read(bookingViewModelProvider(widget.serviceId).notifier).createBookingForUser(
            petIds: selectedPetIds.toList(), // Convert the Set to a List
            storeServiceId: selectedServiceIds.first, // Assuming you want to use the first service ID
            paymentMethod: paymentMethod ?? 'PayOS',
            description: description,
          );

          if (bookingSuccess) {
            // Hiển thị Snackbar khi booking thành công
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Booking success')),
            );

            // Điều hướng về trang Home
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => Home()),
                  (route) => false,
            );
          } else {
            // Xử lý khi booking thất bại (tùy chọn)
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Booking failed, please try again')),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }

}
