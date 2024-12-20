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
    public partial class FrmDoktorGiris : Form
    {
        public FrmDoktorGiris()
        {
            InitializeComponent();
        }
        SqlBaglanti bgl =new SqlBaglanti();
        private void FrmDoktorGiris_Load(object sender, EventArgs e)
        {

        }
        
        private void BtnGiris_Click(object sender, EventArgs e)
        { 

            NpgsqlCommand komut1 = new NpgsqlCommand("Select * From doktor where tcno=@p1 and personelsifre=@p2 ", bgl.baglanti());
            komut1.Parameters.AddWithValue("@p1",mskTc.Text);
            komut1.Parameters.AddWithValue("@p2",TxtSifre.Text);
            NpgsqlDataReader dr = komut1.ExecuteReader();
            if (dr.Read())
            {
                FrmDoktorDetay frm = new FrmDoktorDetay();
                frm.doktorTc = mskTc.Text;
                frm.Show();
                this.Hide();
            }
            else
            {
                MessageBox.Show("Tc No yada Sifre Hatali veya Sisteme kayitli değilsiniz ! ", "UYARI", MessageBoxButtons.OK, MessageBoxIcon.Warning);
            }
            bgl.baglanti().Close();
        }
    }
}
