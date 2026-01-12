package com.agenda.telefonos.adapter

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.agenda.telefonos.R
import com.agenda.telefonos.model.Contact
import com.agenda.telefonos.databinding.ItemContactBinding

class ContactAdapter(
    private var contacts: List<Contact>,
    private val onEditClick: (Contact) -> Unit,
    private val onDeleteClick: (Contact) -> Unit
) : RecyclerView.Adapter<ContactAdapter.ContactViewHolder>() {

    inner class ContactViewHolder(private val binding: ItemContactBinding) :
        RecyclerView.ViewHolder(binding.root) {
        
        fun bind(contact: Contact) {
            binding.apply {
                textViewName.text = contact.name
                textViewPhone.text = contact.phone
                if (contact.email.isNotEmpty()) {
                    textViewEmail.text = contact.email
                }

                buttonEdit.setOnClickListener { onEditClick(contact) }
                buttonDelete.setOnClickListener { onDeleteClick(contact) }
                root.setOnClickListener { onEditClick(contact) }
            }
        }
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ContactViewHolder {
        val binding = ItemContactBinding.inflate(LayoutInflater.from(parent.context), parent, false)
        return ContactViewHolder(binding)
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
