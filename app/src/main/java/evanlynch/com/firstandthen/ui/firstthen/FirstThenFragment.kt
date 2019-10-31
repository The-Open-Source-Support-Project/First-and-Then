package evanlynch.com.firstandthen.ui.firstthen

import android.app.Activity
import android.app.AlertDialog
import androidx.lifecycle.ViewModelProviders
import android.content.Intent
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.Matrix
import android.media.MediaScannerConnection
import android.net.Uri
import android.os.Bundle
import android.os.Environment
import android.provider.MediaStore
import com.google.android.material.floatingactionbutton.FloatingActionButton
import androidx.fragment.app.Fragment
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.Toast
import evanlynch.com.firstandthen.FirstThenActivity
import evanlynch.com.firstandthen.R
import kotlinx.android.synthetic.main.first_then_fragment.view.*
import java.io.*
import java.util.*


class FirstThenFragment : androidx.fragment.app.Fragment() {

    companion object {
        fun newInstance() = FirstThenFragment()
    }
    private var TAG = "FTFrag"
    private lateinit var viewModel: FirstThenViewModel
    private lateinit var model: SharedViewModel
    private lateinit var imgToBeUpdated: String
    private val IMAGE_DIRECTORY = "/demonuts"
    private val GALLERY = 1
    private val CAMERA = 2
    var SCREEN_LOCK = false

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        val view: View = inflater.inflate(R.layout.first_then_fragment, container, false)

        view.firstImg.setOnClickListener{
           //openImageSelectore()
            imgToBeUpdated = "first"
            if (SCREEN_LOCK == false){
                showPictureDialog()
            }

        }
        view.thenImg.setOnClickListener{
            //openImageSelectore()
            imgToBeUpdated = "then"
            if (SCREEN_LOCK == false){
                showPictureDialog()
            }


        }
        view.screenLock.setOnClickListener {
            if (SCREEN_LOCK == false){
                SCREEN_LOCK = true
                Toast.makeText(this.context, "Child Lock Enabled", Toast.LENGTH_SHORT).show()

            }else{
                SCREEN_LOCK = false
                Toast.makeText(this.context, "Child Lock Disabled", Toast.LENGTH_SHORT).show()
            }
        }
        return view
    }

    private fun showPictureDialog() {
        val pictureDialog = AlertDialog.Builder(this.context)
        pictureDialog.setTitle("Select Action")
        val pictureDialogItems = arrayOf("Select photo from gallery", "Capture photo from camera")
        pictureDialog.setItems(pictureDialogItems
        ) { _, which ->
            when (which) {
                0 -> choosePhotoFromGallary()
                1 -> takePhotoFromCamera()
            }
        }
        pictureDialog.show()

    }

    private fun takePhotoFromCamera() {
        val intent = Intent(MediaStore.ACTION_IMAGE_CAPTURE)
        startActivityForResult(intent, CAMERA)
    }

    private fun choosePhotoFromGallary() {
        val galleryIntent = Intent(
            Intent.ACTION_PICK,
            MediaStore.Images.Media.EXTERNAL_CONTENT_URI
        )

        startActivityForResult(galleryIntent, GALLERY)
    }

    override fun onActivityResult(requestCode:Int, resultCode:Int, data: Intent?) {

        super.onActivityResult(requestCode, resultCode, data)
//        if (resultCode == this.RESULT_CANCELED)
//         {
//         return
//         }
        var imageView = ImageView(context)
        if(imgToBeUpdated == "then"){
            imageView = view!!.thenImg
        }else{
            imageView = view!!.firstImg
        }

        if (requestCode == GALLERY)
        {
            if (data != null)
            {
                val contentURI = data.data
                try
                {

                    val bitmap = MediaStore.Images.Media.getBitmap(this.context!!.contentResolver, contentURI)
                    val path = saveImage(bitmap)
                    Toast.makeText(this.context, "Image Saved!", Toast.LENGTH_SHORT).show()
                    imageView.setImageBitmap(bitmap)

                }
                catch (e: IOException) {
                    e.printStackTrace()
                    Toast.makeText(this.context, "Failed!", Toast.LENGTH_SHORT).show()
                }

            }

        }
        else if (requestCode == CAMERA)
        {
            val thumbnail = data!!.extras!!.get("data") as Bitmap
            val matrix = Matrix()

            matrix.postRotate(90F)
            val rotatedBitmap = Bitmap.createBitmap(thumbnail, 0, 0, thumbnail.width, thumbnail.height, matrix, true)

            imageView.setImageBitmap(thumbnail)
            saveImage(thumbnail)
            Toast.makeText(this.context, "Image Saved!", Toast.LENGTH_SHORT).show()
        }
    }

    fun saveImage(myBitmap: Bitmap):String {
        val bytes = ByteArrayOutputStream()
        myBitmap.compress(Bitmap.CompressFormat.JPEG, 90, bytes)
        val imgDirectory = File(
            (Environment.getExternalStorageDirectory()).toString() + IMAGE_DIRECTORY)
        // have the object build the directory structure, if needed.
        Log.d("fee",imgDirectory.toString())
        if (!imgDirectory.exists())
        {
            imgDirectory.mkdirs()
        }

        try
        {
            Log.d("heel",imgDirectory.toString())
            val f = File(imgDirectory, ((Calendar.getInstance()
                .timeInMillis).toString() + ".jpg"))
            f.createNewFile()
            val fo = FileOutputStream(f)
            fo.write(bytes.toByteArray())
            MediaScannerConnection.scanFile(this.context,
                arrayOf(f.path),
                arrayOf("image/jpeg"), null)
            fo.close()
            Log.d("TAG", "File Saved::--->" + f.absolutePath)

            return f.absolutePath
        }
        catch (e1: IOException) {
            e1.printStackTrace()
        }

        return ""
    }

    override fun onActivityCreated(savedInstanceState: Bundle?) {
        super.onActivityCreated(savedInstanceState)
        viewModel = ViewModelProviders.of(this).get(FirstThenViewModel::class.java)
        // TODO: Use the ViewModel
    }



}
