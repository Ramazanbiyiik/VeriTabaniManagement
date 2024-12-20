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
    public partial class FrmDoktorBilgiDuzenle : Form
    {
        public FrmDoktorBilgiDuzenle()
        {
            InitializeComponent();
        }
        SqlBaglanti bgl = new  SqlBaglanti();
        public string tcDoktor;
        private void FrmDoktorBilgiDuzenle_Load(object sender, EventArgs e)
        {
            MskTc.Text= tcDoktor;

            NpgsqlCommand cmd = new NpgsqlCommand("Select * From doktor Where tcno=@p1",bgl.baglanti());
            cmd.Parameters.AddWithValue("@p1", MskTc.Text); 
            NpgsqlDataReader dr = cmd.ExecuteReader();
            while (dr.Read())
            {
                TxtAd.Text = dr[1].ToString();
                TxtSoyad.Text = dr[2].ToString();
                CmbBrans.Text = dr[8].ToString();
                TxtSifre.Text = dr[5].ToString();
            }
            bgl.baglanti().Close();
        }

        private void BtnBilgiGuncelle_Click(object sender, EventArgs e)
        {
            NpgsqlCommand cmd = new NpgsqlCommand("Update doktor set ad=@p1,soyad=@p2, bransad=@p3, personelsifre=@p4 where tcno=@p5", bgl.baglanti());
            cmd.Parameters.AddWithValue("@p1", TxtAd.Text);
            cmd.Parameters.AddWithValue("@p2", TxtSoyad.Text);
            cmd.Parameters.AddWithValue("@p3", CmbBrans.Text);
            cmd.Parameters.AddWithValue("@p4", TxtSifre.Text);
            cmd.Parameters.AddWithValue("@p5", MskTc.Text);
            cmd.ExecuteNonQuery();
            bgl.baglanti().Close();
            MessageBox.Show("Bilgi Güncelleme isleminiz tamamlanmistir");
        }
    }
}
