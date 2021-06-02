import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrGenerator extends StatefulWidget {
  @override
  _QrGeneratorState createState() => _QrGeneratorState();
}



class _QrGeneratorState extends State<QrGenerator> {

  TextEditingController qrController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size  size = MediaQuery.of(context).size;
    return Scaffold(
      body:
        Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextFormField(
                controller: qrController,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                      RegExp('[a-z,A-Z,_]')),],
                autofillHints: [AutofillHints.givenName],
                decoration: InputDecoration(
                  errorStyle: TextStyle(
                    color: Colors.red,
                  fontSize: 15,
                  ),
                  labelText: 'Enter Shop Name Divide them Using "_" (Example Dropin_castle) ',
                  hintStyle: TextStyle(color: Colors.grey,
                  fontSize: 15,),
                  prefixIcon: Icon(Icons.link),
                ),
                onEditingComplete: navigate,
              ),
              SizedBox(
                width: size.width * 0.5,
                child: ElevatedButton(

                  style: ElevatedButton.styleFrom(
                      elevation: 20,
                      side: BorderSide(width: 1,
                        color:  Colors.deepOrange,),
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0),
                      ),
                      primary: Colors.grey.shade200,
                      onPrimary: Colors.white),
                  onPressed: navigate,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Generate QR Code",
                          style: TextStyle(
                            color:  Colors.deepOrange,
                            fontSize: size.width * 0.02,
                          ),
                        ),
                        SizedBox(
                          width: size.width * 0.01,
                        ),
                        Icon(
                          Icons.thumb_up_alt_outlined,
                          color:Colors.deepOrange,
                          size: size.width * 0.02,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
    );
  }

  void navigate(){
    Navigator.push(context, MaterialPageRoute(builder: (context)=> QrCodes(qrController.text),));
  }
}



class QrCodes extends StatefulWidget {
  final  qrCode;

  const QrCodes(this.qrCode) ;
  @override
  _QrCodesState createState() => _QrCodesState();
}

class _QrCodesState extends State<QrCodes> {
  @override
  Widget build(BuildContext context) {
    // print('http://localhost:49782/#${widget.qrCode}');
    // String filename = 'http://localhost:49782/#${widget.qrCode}';
    // print(filename.split('#').last);
    return Scaffold(
      appBar: AppBar(
        title: Text('Qr Code Generator '),
      ),
      body: Center(
        child: QrImage(
          data: 'https://check-in-system-7b9a4.web.app/#${widget.qrCode}',
          version:  QrVersions.auto,
          size: 250,) ,
      ),
    );
  }
}
