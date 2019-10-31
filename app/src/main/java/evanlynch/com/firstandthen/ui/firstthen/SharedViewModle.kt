package evanlynch.com.firstandthen.ui.firstthen

import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import android.content.ClipData

class SharedViewModel : ViewModel() {
    val selectedItem = MutableLiveData<ClipData.Item>()
    val selectedImg = MutableLiveData<ClipData.Item>()

    fun selectedItem(item: ClipData.Item) {
        selectedItem.value = item
    }
    fun selectedImg(item: ClipData.Item){
        selectedImg.value = item
    }
}

