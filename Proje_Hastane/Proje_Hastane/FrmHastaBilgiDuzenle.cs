using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using Npgsql;

namespace Proje_Hastane
{
    public partial class FrmHastaBilgiDuzenle : Form
    {
        public FrmHastaBilgiDuzenle()
        {
            InitializeComponent();
        } 
        SqlBaglanti bgl = new SqlBaglanti();
        public string tcNo;
        private void FrmHastaBilgiDuzenle_Load(object sender, EventArgs e)
        {
            MskTc.Text = tcNo;

            NpgsqlCommand komut1 = new NpgsqlCommand("Select * From hasta where tcno=@p1 ",bgl.baglanti());
            komut1.Parameters.AddWithValue("@p1",MskTc.Text);
            NpgsqlDataReader dr1 = komut1.ExecuteReader();
            while (dr1.Read())
            {
                TxtAd.Text = dr1[1].ToString();
                TxtSoyad.Text = dr1[2].ToString();
                MskTc.Text = dr1[3].ToString();
                MskTelefon.Text = dr1[6].ToString();
                TxtSifre.Text = dr1[5].ToString();
                
            }
            bgl.baglanti().Close();
        }

        private void BtnBilgiGuncelle_Click(object sender, EventArgs e)
        {
            NpgsqlCommand komut2 = new NpgsqlCommand("Update  hasta set  ad=@p1,soyad=@p2, telefon=@p3, hastasifre=@p4  Where tcno=@p6  ", bgl.baglanti());
            komut2.Parameters.AddWithValue("@p1", TxtAd.Text);
            komut2.Parameters.AddWithValue("@p2", TxtSoyad.Text);
            komut2.Parameters.AddWithValue("@p3", MskTelefon.Text);
            komut2.Parameters.AddWithValue("@p4", TxtSifre.Text);
            komut2.Parameters.AddWithValue("@p6", MskTc.Text);
            komut2.ExecuteNonQuery();
            bgl.baglanti().Close();
            MessageBox.Show("Hasta Bilgi Duzenleme Isleminiz Gerceklesmistir Sifreniz" + TxtSifre.Text, "Bilgi", MessageBoxButtons.OK, MessageBoxIcon.Information);
        }
    }
}
