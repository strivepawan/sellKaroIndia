import 'package:flutter/material.dart';

const Map<String, List<String>> stateCityMap = {
  'Andhra Pradesh': [
    'Amaravati', 'Anantapur', 'Chittoor', 'Eluru', 'Guntur', 'Kadapa', 'Kakinada', 
    'Kurnool', 'Nellore', 'Ongole', 'Rajahmundry', 'Srikakulam', 'Tirupati', 
    'Vijayawada', 'Visakhapatnam', 'Vizianagaram'
  ],
  'Arunachal Pradesh': [
    'Bomdila', 'Itanagar', 'Pasighat', 'Roing', 'Tawang', 'Ziro'
  ],
  'Assam': [
    'Barpeta', 'Bongaigaon', 'Dibrugarh', 'Diphu', 'Dispur', 'Goalpara', 
    'Guwahati', 'Jorhat', 'Nagaon', 'Silchar', 'Tezpur', 'Tinsukia'
  ],
  'Bihar': [
    'Arrah', 'Begusarai', 'Bhagalpur', 'Bihar Sharif', 'Bodh Gaya', 'Buxar', 
    'Darbhanga', 'Gaya', 'Hajipur', 'Katihar', 'Muzaffarpur', 'Patna', 
    'Purnia', 'Saharsa', 'Samastipur'
  ],
  'Chhattisgarh': [
    'Ambikapur', 'Bhilai', 'Bilaspur', 'Dhamtari', 'Durg', 'Jagdalpur', 
    'Korba', 'Raigarh', 'Raipur', 'Rajnandgaon'
  ],
  'Goa': [
    'Bicholim', 'Mapusa', 'Margao', 'Panaji', 'Ponda', 'Vasco da Gama'
  ],
  'Gujarat': [
    'Ahmedabad', 'Amreli', 'Anand', 'Bhavnagar', 'Bhuj', 'Dwarka', 'Gandhinagar', 
    'Godhra', 'Jamnagar', 'Junagadh', 'Mehsana', 'Nadiad', 'Navsari', 
    'Palanpur', 'Patan', 'Porbandar', 'Rajkot', 'Surat', 'Surendranagar', 
    'Vadodara', 'Valsad', 'Veraval'
  ],
  'Haryana': [
    'Ambala', 'Bhiwani', 'Faridabad', 'Fatehabad', 'Gurgaon', 'Hisar', 'Jhajjar', 
    'Jind', 'Kaithal', 'Karnal', 'Kurukshetra', 'Panipat', 'Rewari', 
    'Rohtak', 'Sirsa', 'Sonipat', 'Yamunanagar'
  ],
  'Himachal Pradesh': [
    'Bilaspur', 'Chamba', 'Dharamshala', 'Hamirpur', 'Kangra', 'Kullu', 'Mandi', 
    'Nahan', 'Shimla', 'Solan', 'Una'
  ],
  'Jharkhand': [
    'Bokaro', 'Chaibasa', 'Chatra', 'Deoghar', 'Dhanbad', 'Dumka', 'Giridih', 
    'Godda', 'Gumla', 'Hazaribagh', 'Jamshedpur', 'Jamtara', 'Khunti', 
    'Koderma', 'Latehar', 'Lohardaga', 'Pakur', 'Palamu', 'Ramgarh', 
    'Ranchi', 'Sahebganj', 'Simdega'
  ],
  'Karnataka': [
    'Bagalkot', 'Bangalore', 'Belgaum', 'Bellary', 'Bidar', 'Bijapur', 
    'Chikmagalur', 'Chitradurga', 'Davangere', 'Dharwad', 'Gadag', 'Gulbarga', 
    'Hassan', 'Hubli', 'Kolar', 'Mangalore', 'Mysore', 'Raichur', 'Shimoga', 
    'Tumkur', 'Udupi'
  ],
  'Kerala': [
    'Alappuzha', 'Ernakulam', 'Idukki', 'Kannur', 'Kasargod', 'Kochi', 
    'Kollam', 'Kottayam', 'Kozhikode', 'Malappuram', 'Palakkad', 
    'Pathanamthitta', 'Thiruvananthapuram', 'Thrissur', 'Wayanad'
  ],
  'Madhya Pradesh': [
    'Balaghat', 'Betul', 'Bhind', 'Bhopal', 'Chhatarpur', 'Chhindwara', 
    'Damoh', 'Datia', 'Dewas', 'Dhar', 'Guna', 'Gwalior', 'Hoshangabad', 
    'Indore', 'Jabalpur', 'Katni', 'Khandwa', 'Khargone', 'Mandsaur', 
    'Morena', 'Neemuch', 'Panna', 'Ratlam', 'Rewa', 'Sagar', 'Satna', 
    'Sehore', 'Seoni', 'Shahdol', 'Shivpuri', 'Sidhi', 'Singrauli', 'Tikamgarh', 
    'Ujjain', 'Vidisha'
  ],
  'Maharashtra': [
    'Ahmednagar', 'Akola', 'Amravati', 'Aurangabad', 'Beed', 'Bhandara', 
    'Bhusawal', 'Chandrapur', 'Dhule', 'Gondia', 'Ichalkaranji', 'Jalgaon', 
    'Jalna', 'Kolhapur', 'Latur', 'Mumbai', 'Nagpur', 'Nanded', 'Nashik', 
    'Osmanabad', 'Pune', 'Ratnagiri', 'Sangli', 'Satara', 'Solapur', 
    'Thane', 'Ulhasnagar', 'Vasai-Virar', 'Wardha', 'Yavatmal'
  ],
  'Manipur': [
    'Bishnupur', 'Chandel', 'Churachandpur', 'Imphal', 'Senapati', 'Tamenglong', 
    'Thoubal', 'Ukhrul'
  ],
  'Meghalaya': [
    'Baghmara', 'Cherrapunjee', 'Jowai', 'Mairang', 'Nongpoh', 'Nongstoin', 
    'Shillong', 'Tura', 'Williamnagar'
  ],
  'Mizoram': [
    'Aizawl', 'Champhai', 'Kolasib', 'Lawngtlai', 'Lunglei', 'Mamit', 
    'Serchhip', 'Siaha'
  ],
  'Nagaland': [
    'Dimapur', 'Kiphire', 'Kohima', 'Longleng', 'Mokokchung', 'Mon', 
    'Peren', 'Phek', 'Tuensang', 'Wokha', 'Zunheboto'
  ],
  'Odisha': [
    'Balangir', 'Balasore', 'Baripada', 'Berhampur', 'Bhubaneswar', 
    'Cuttack', 'Dhenkanal', 'Jagatsinghpur', 'Jajpur', 'Jharsuguda', 
    'Kalahandi', 'Kendrapara', 'Kendujhar', 'Koraput', 'Malkangiri', 
    'Nabarangpur', 'Paradip', 'Puri', 'Rayagada', 'Rourkela', 'Sambalpur'
  ],
  'Punjab': [
    'Amritsar', 'Barnala', 'Bathinda', 'Faridkot', 'Fatehgarh Sahib', 
    'Fazilka', 'Firozpur', 'Gurdaspur', 'Hoshiarpur', 'Jalandhar', 
    'Kapurthala', 'Ludhiana', 'Mansa', 'Moga', 'Mohali', 'Muktsar', 
    'Pathankot', 'Patiala', 'Rupnagar', 'Sangrur', 'Tarn Taran'
  ],
  'Rajasthan': [
    'Ajmer', 'Alwar', 'Banswara', 'Baran', 'Barmer', 'Bharatpur', 
    'Bhilwara', 'Bikaner', 'Bundi', 'Chittorgarh', 'Churu', 'Dausa', 
    'Dholpur', 'Dungarpur', 'Hanumangarh', 'Jaipur', 'Jaisalmer', 'Jalore', 
    'Jhalawar', 'Jhunjhunu', 'Jodhpur', 'Karauli', 'Kota', 'Nagaur', 
    'Pali', 'Pratapgarh', 'Rajsamand', 'Sawai Madhopur', 'Sikar', 
    'Sirohi', 'Sri Ganganagar', 'Tonk', 'Udaipur'
  ],
  'Sikkim': [
    'Gangtok', 'Gyalshing', 'Mangan', 'Namchi', 'Rangpo'
  ],
  'Tamil Nadu': [
    'Chennai', 'Coimbatore', 'Cuddalore', 'Dharmapuri', 'Dindigul', 
    'Erode', 'Kanchipuram', 'Kanyakumari', 'Karur', 'Madurai', 'Nagapattinam', 
    'Namakkal', 'Perambalur', 'Pudukkottai', 'Ramanathapuram', 'Salem', 
    'Sivaganga', 'Thanjavur', 'Theni', 'Thoothukudi', 'Tiruchirappalli', 
    'Tirunelveli', 'Tiruppur', 'Tiruvannamalai', 'Vellore', 'Villupuram', 
    'Virudhunagar'
  ],
  'Telangana': [
    'Adilabad', 'Hyderabad', 'Jagtial', 'Jangaon', 'Karimnagar', 
    'Khammam', 'Mahbubnagar', 'Mancherial', 'Medak', 'Nalgonda', 'Nizamabad', 
    'Peddapalli', 'Ramagundam', 'Sangareddy', 'Siddipet', 'Suryapet', 
    'Warangal'
  ],
  'Tripura': [
    'Agartala', 'Ambassa', 'Dharmanagar', 'Kailashahar', 'Khowai', 
    'Udaipur'
  ],
  'Uttar Pradesh': [
    'Agra', 'Aligarh', 'Allahabad', 'Amroha', 'Auraiya', 'Azamgarh', 
    'Bareilly', 'Basti', 'Bijnor', 'Bulandshahr', 'Deoria', 'Etah', 
    'Etawah', 'Faizabad', 'Farrukhabad', 'Fatehpur', 'Firozabad', 
    'Ghaziabad', 'Ghazipur', 'Gonda', 'Gorakhpur', 'Hamirpur', 'Hardoi', 
    'Hathras', 'Jaunpur', 'Jhansi', 'Kannauj', 'Kanpur', 'Kheri', 
    'Lucknow', 'Mathura', 'Mau', 'Meerut', 'Mirzapur', 'Moradabad', 
    'Muzaffarnagar', 'Noida', 'Orai', 'Pilibhit', 'Pratapgarh', 'Rae Bareli', 
    'Rampur', 'Saharanpur', 'Sambhal', 'Shahjahanpur', 'Sitapur', 
    'Sultanpur', 'Unnao', 'Varanasi'
  ],
  'Uttarakhand': [
    'Almora', 'Bageshwar', 'Dehradun', 'Haldwani', 'Haridwar', 
    'Kashipur', 'Nainital', 'Pauri', 'Pithoragarh', 'Rishikesh', 
    'Roorkee', 'Rudrapur', 'Tehri'
  ],
  'West Bengal': [
    'Alipurduar', 'Asansol', 'Balurghat', 'Bankura', 'Bardhaman', 
    'Berhampore', 'Chinsurah', 'Cooch Behar', 'Darjeeling', 'Durgapur', 
    'Haldia', 'Howrah', 'Jalpaiguri', 'Kalimpong', 'Kharagpur', 
    'Kolkata', 'Krishnanagar', 'Malda', 'Midnapore', 'Murshidabad', 
    'Nabadwip', 'Purulia', 'Raiganj', 'Siliguri'
  ],
};


class CitySelectionScreen extends StatefulWidget {
  const CitySelectionScreen({super.key});

  @override
  _CitySelectionScreenState createState() => _CitySelectionScreenState();
}

class _CitySelectionScreenState extends State<CitySelectionScreen> {
  String? _selectedState;
  List<String> _cities = [];

  void _onStateSelected(String? state) {
    setState(() {
      _selectedState = state;
      _cities = stateCityMap[state] ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select City'),
      ),
      body: Column(
        children: [
          DropdownButton<String>(
            hint: const Text('Select State'),
            value: _selectedState,
            onChanged: _onStateSelected,
            items: stateCityMap.keys.map((String state) {
              return DropdownMenuItem<String>(
                value: state,
                child: Text(state),
              );
            }).toList(),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _cities.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_cities[index]),
                  onTap: () {
                    Navigator.pop(context, _cities[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
