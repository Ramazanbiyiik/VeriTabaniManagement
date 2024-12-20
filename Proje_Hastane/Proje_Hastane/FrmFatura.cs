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
    public partial class FrmFatura : Form
    {
        public FrmFatura()
        {
            InitializeComponent();
        }
        SqlBaglanti bgl = new SqlBaglanti();
        private void button1_Click(object sender, EventArgs e)
        {
            NpgsqlCommand komut = new NpgsqlCommand("Update fatura set odemedurumu=True where id=@p1", bgl.baglanti());
            komut.Parameters.AddWithValue("@p1", int.Parse(textBox1.Text));
            komut.ExecuteNonQuery();
            bgl.baglanti().Close();
            MessageBox.Show("Fatura Durumu Güncellendi", "Bilgi", MessageBoxButtons.OK, MessageBoxIcon.Information);
        }

        private void FrmFatura_Load(object sender, EventArgs e)
        {
           
            DataTable dt = new DataTable();
            NpgsqlDataAdapter da = new NpgsqlDataAdapter("Select * From fatura ", bgl.baglanti());
            da.Fill(dt);
            dataGridView1.DataSource = dt;

        }

        private void button2_Click(object sender, EventArgs e)
        {
            NpgsqlCommand komutKaydet = new NpgsqlCommand("insert into randevular (kisiid,randevuid,toplamtutar) values (@r1,@r2,@r3)", bgl.baglanti());
            komutKaydet.Parameters.AddWithValue("@r1", TxtKid.Text);
            komutKaydet.Parameters.AddWithValue("@r2", TxtRid.Text);
            komutKaydet.Parameters.AddWithValue("@r3", TxtOdeme.Text);
            komutKaydet.ExecuteNonQuery();
            bgl.baglanti().Close();
            MessageBox.Show("Fatura Oluşturuldu");
        }

        private void label2_Click(object sender, EventArgs e)
        {

        }

        private void label5_Click(object sender, EventArgs e)
        {

        }

        private void dataGridView1_CellMouseDoubleClick(object sender, DataGridViewCellMouseEventArgs e)
        {
            int secilen = dataGridView1.SelectedCells[0].RowIndex;
            textBox1.Text = dataGridView1.Rows[secilen].Cells[0].Value.ToString();
            TxtKid.Text = dataGridView1.Rows[secilen].Cells[1].Value.ToString();
            TxtRid.Text = dataGridView1.Rows[secilen].Cells[2].Value.ToString();
            TxtOdeme.Text = dataGridView1.Rows[secilen].Cells[3].Value.ToString();
        }
    }
}
