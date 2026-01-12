package com.agenda.telefonos.adapter

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.agenda.telefonos.R
import com.agenda.telefonos.model.Contact
import android.widget.Button
import android.widget.LinearLayout
import android.widget.TextView

class ContactAdapter(
    private var contacts: List<Contact>,
    private val onEditClick: (Contact) -> Unit,
    private val onDeleteClick: (Contact) -> Unit
) : RecyclerView.Adapter<ContactAdapter.ContactViewHolder>() {

    inner class ContactViewHolder(itemView: android.view.View) : RecyclerView.ViewHolder(itemView) {
        private val textViewName: TextView = itemView.findViewById(R.id.textViewName)
        private val textViewPhone: TextView = itemView.findViewById(R.id.textViewPhone)
        private val textViewEmail: TextView = itemView.findViewById(R.id.textViewEmail)
        private val buttonEdit: Button = itemView.findViewById(R.id.buttonEdit)
        private val buttonDelete: Button = itemView.findViewById(R.id.buttonDelete)

        fun bind(contact: Contact) {
            textViewName.text = contact.name
            textViewPhone.text = contact.phone
            if (contact.email.isNotEmpty()) {
                textViewEmail.text = contact.email
                textViewEmail.visibility = android.view.View.VISIBLE
            } else {
                textViewEmail.visibility = android.view.View.GONE
            }

            buttonEdit.setOnClickListener { onEditClick(contact) }
            buttonDelete.setOnClickListener { onDeleteClick(contact) }
            itemView.setOnClickListener { onEditClick(contact) }
        }
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ContactViewHolder {
        val view = LayoutInflater.from(parent.context).inflate(R.layout.item_contact, parent, false)
        return ContactViewHolder(view)
    }

    override fun onBindViewHolder(holder: ContactViewHolder, position: Int) {
        holder.bind(contacts[position])
    }

    override fun getItemCount() = contacts.size

    fun updateContacts(newContacts: List<Contact>) {
        contacts = newContacts
        notifyDataSetChanged()
    }
}
